# == Class: ceph::radosgw
#
# Installs a rados gateway
#
# === Examples
#
# In your manifest
#
#   include ::ceph::radosgw
#
# Keys will be automatically installed based on ceph::params::client_keys
# see the main README for mor details
#
class ceph::radosgw {

  include ceph
  Class['::ceph'] -> Class['::ceph::radosgw']

  contain ceph::radosgw::install
  contain ceph::radosgw::configure
  contain ceph::radosgw::service

  Class['::ceph::radosgw::install'] ->
  Class['::ceph::radosgw::configure'] ~>
  Class['::ceph::radosgw::service']

}
