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

  exec { "ssh -F /home/${ceph::params::deploy_user}/.ssh/config -i /home/${ceph::params::deploy_user}/.ssh/id_rsa ${ceph::params::deploy_user}@${ceph::params::mon_initial_member} \"ceph osd pool create ${name} ${pg_num} ${pg_num}\" >> ${keyring}":
    unless =>  "ssh -F /home/${ceph::params::deploy_user}/.ssh/config -i /home/${ceph::params::deploy_user}/.ssh/id_rsa ${ceph::params::deploy_user}@${ceph::params::mon_initial_member} \"ceph osd lspools\" | grep ${name}",
  }

}
