# == Class: ceph::mon
#
# Creates a ceph monitor node
#
class ceph::mon {

  include ceph
  Class['::ceph'] -> Class['::ceph::mon']

  ceph::keyring { 'ceph.mon.keyring':
    user     => 'mon.',
    key      => $ceph::params::monitor_secret,
    caps_mon => 'allow *',
    path     => "/home/${ceph::params::deploy_user}",
    owner    => $ceph::params::deploy_user,
    group    => $ceph::params::deploy_user,
  } ->

  exec { 'deploy-mon':
    command => "ceph-deploy mon create ${::hostname}",
    cwd     => "/home/${ceph::params::deploy_user}",
    unless  => "ceph --cluster=ceph --admin-daemon /var/run/ceph/ceph-mon.${::hostname}.asok mon_status"
  }

  # Create client keys not part of the provisioning process
  if $::hostname == $ceph::params::mon_initial_member {

    $defaults = {
      require => Exec['deploy-mon'],
    }
    create_resources('ceph::client_key', $ceph::params::client_keys, $defaults)

  }

}
