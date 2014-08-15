# == Class: ceph::radosgw::install
#
# Installs the packages required for a rados gateway
#
class ceph::radosgw::install {

  package { 'radosgw':
    ensure => installed,
  }

}
