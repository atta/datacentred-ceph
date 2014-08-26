# == Class: ceph::mon
#
# Creates a ceph monitor node
#
class ceph::mon {

  include ceph
  Class['::ceph'] -> Class['::ceph::mon']

  Exec {
    user        => $ceph::params::deploy_user,
    environment => "USER=${ceph::params::deploy_user}",
    cwd         => "/home/${ceph::params::deploy_user}",
  }

  ceph::keyring { 'ceph.mon.keyring':
    user     => 'mon.',
    key      => $ceph::params::monitor_secret,
    caps_mon => 'allow *',
    path     => "/home/${ceph::params::deploy_user}",
    owner    => $ceph::params::deploy_user,
    group    => $ceph::params::deploy_user,
  } ->

  exec { 'deploy-mon':
    command     => "ceph-deploy --overwrite-conf mon create ${::hostname}",
    user        => $ceph::params::deploy_user,
    environment => "USER=${ceph::params::deploy_user}",
    cwd         => "/home/${ceph::params::deploy_user}",
    unless      => "sudo ceph --cluster=ceph --admin-daemon /var/run/ceph/ceph-mon.${::hostname}.asok mon_status"
  }

}
