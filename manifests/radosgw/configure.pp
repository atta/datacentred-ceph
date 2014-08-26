# == Class: ceph::radosgw::configure
#
# Configure the rados gateway
#
class ceph::radosgw::configure {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  contain ceph::radosgw::configure::apache

  ceph::client { "radosgw.${::hostname}":
    perms => 'mon \"allow rwx\" osd \"allow rwx\"',
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
