# == Class: ceph::radosgw::service
#
# Ensure the rados server and http daemon are running
#
class ceph::radosgw::service {

  service { 'radosgw-all':
    ensure => running,
  }

}
