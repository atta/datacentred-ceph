# == Class: ceph::radosgw::install
#
# Installs the packages required for a rados gateway
#
class ceph::radosgw::install {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  package { 'radosgw':
    ensure => installed,
  }

}
