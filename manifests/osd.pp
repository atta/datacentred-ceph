# == Class: ceph::osd
#
# Wrapper around the simple OSD class to support multiple disks per host and
# give hiera support
#
# === Examples
#
# Manifest:
#
#   include ::ceph::osd
#
# Hiera:
#
#   ceph::params::disks:
#     - 'sdb:/dev/sdd1'
#     - 'sdc:/dev/sdd1'
#
# See ceph::osd for more details on individual list items
#
class ceph::osd {

  include ::ceph
  Class['::ceph'] -> Class['ceph::osd']

  concat::fragment { "ceph.osd.conf":
    target  => '/etc/ceph/ceph.conf',
    content => template('ceph/ceph.osd.conf.erb'),
    order   => '20',
  }

  ceph::osd_private { $ceph::params::disks: }

}
