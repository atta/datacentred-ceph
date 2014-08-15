# == Class: ceph::radosgw::configure
#
# Configure the rados gateway
#
class ceph::radosgw::configure {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  contain ceph::radosgw::configure::apache

  $user = "client.radosgw.${::hostname}"
  $keyring = "/etc/ceph/ceph.client.radosgw.keyring"

  # Please do this for me ceph deploy...
  exec { "echo -n '[${user}]\\n\\tkey = ' > ${keyring}":
    unless => "ls ${keyring}",
  } ~>

  exec { "ssh -F /home/${ceph::params::deploy_user}/.ssh/config -i /home/${ceph::params::deploy_user}/.ssh/id_rsa ${ceph::params::deploy_user}@${ceph::params::mon_initial_member} sudo \"ceph auth get-or-create-key ${user} mon 'allow *' osd 'allow *'\" >> ${keyring}":
    refreshonly => true,
  } ->

  concat { '/etc/ceph/ceph.conf':
    ensure => 'present',
  }

  concat::fragment { 'ceph.conf':
    target  => '/etc/ceph/ceph.conf',
    content => template('ceph/ceph.conf.erb'),
    order   => '10',
  }

  concat::fragment { 'ceph.radosgw.conf':
    target  => '/etc/ceph/ceph.conf',
    content => template('ceph/ceph.radosgw.conf.erb'),
    order   => '20',
  }

  file { "/var/lib/ceph/radosgw/ceph-radosgw.${hostname}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Undocumented but the init scripts rely on this file existing
  file { "/var/lib/ceph/radosgw/ceph-radosgw.${hostname}/done":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
