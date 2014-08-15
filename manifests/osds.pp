# == Class: ceph::osds
#
# Wrapper around the simple OSD class to support multiple disks per host and
# give hiera support
#
# === Examples
#
# Manifest:
#
#   include ::ceph::osds
#
# Hiera:
#
#   ceph::osds::disks:
#     - 'sdb:/dev/sdd1'
#     - 'sdc:/dev/sdd1'
#
# See ceph::osd for more details on individual list items
#
class ceph::osds (
  $disks,
) {

  ceph::osd { $disks: }

}
