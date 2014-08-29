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

  exec { "ssh ${ceph::params::mon_initial_member} \"sudo ceph osd pool create ${name} ${pg_num} ${pg_num}\"":
    unless =>  "ssh ${ceph::params::mon_initial_member} \"sudo ceph osd lspools\" | grep ${name}",
    user  => $ceph::params::deploy_user,
    group => $ceph::params::deploy_user,
  }

}
