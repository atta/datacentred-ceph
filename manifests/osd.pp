# == Define: ceph::osd
#
# Provision an OSD
#
# === Examples
#
# ceph::osd { 'sdb:/dev/sdg1': }
#
# Two parameters are specified inline separated by a colon.  The first is
# the OSD proper, the second is the journal device, typically an SSD.
#
define ceph::osd {

  include ceph
  Class['::ceph'] -> Ceph::Osd[$name]

  $fields = split($name, ':')
  $disk = $fields[0]

  exec { "${disk}: gather-keys":
    command => "ceph-deploy gatherkeys ${ceph::params::mon_initial_member}",
    cwd     => "/home/${ceph::params::deploy_user}",
    unless  => "ls /home/${ceph::params::deploy_user}/ceph.bootstrap-osd.keyring",
  } ->

  exec { "ceph-deploy disk zap ${::hostname}:${disk}":
    cwd    => "/home/${ceph::params::deploy_user}",
    unless => "ls /home/${ceph::params::deploy_user}/${disk}",
  } ->

  exec { "ceph-deploy osd create ${::hostname}:${name}":
    cwd    => "/home/${ceph::params::deploy_user}",
    unless => "ls /home/${ceph::params::deploy_user}/${disk}",
  } ->

  file { "/home/${ceph::params::deploy_user}/${disk}":
    ensure => present,
  }

}
