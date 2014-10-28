# == Define: ceph::pool
#
# Defines a pool in a cluster
#
# === Parameters
#
# [*name*]
#   Name of the pool e.g. .uk-manchester.rgw.root
#
# [*pg_num*]
#   Number of placement groups for this pool in the cluster
#   see the ceph documentation for guidance on correct values
#
define ceph::pool (
  $pg_num,
) {

  include ::ceph::params

  $mon_array = split($ceph::params::mon_initial_member, ',')
  $mon = $mon_array[0]

  exec { "ssh ${mon} \"sudo ceph osd pool create ${name} ${pg_num} ${pg_num}\"":
    unless =>  "ssh ${mon} \"sudo ceph osd lspools\" | grep ${name}",
    user   => $ceph::params::deploy_user,
    group  => $ceph::params::deploy_user,
  }

}
