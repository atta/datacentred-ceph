# == Class: ceph::radosgw::service
#
# Ensure the rados server and http daemon are running
#
class ceph::radosgw::service {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  service { 'radosgw-all':
    ensure    => running,
    subscribe => Class['::ceph::config'],
  }

}
