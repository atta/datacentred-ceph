# == Class: ceph::params
#
# Parameter container class.  Override with hiera
# data bindings
#
# === Parameters
#
# [*deploy_user*]
#   User account to create when deploying ceph
#
# [*deploy_user_is_system*]
#   Whether to create a system account for the deploy user
#
# [*fsid*]
#   The UUID of the cluster
#
# [*mon_initial_member*]
#   The shortname of the first monitor to provision
#
# [*mon_host*]
#   The IP address of the first monitor to provision
#
# [*public_network*]
#   The public network of the cluster in CIDR
#
# [*cluster_network*]
#   The private network of the cluster in CIDR
#
# [*monitor_secret*]
#   The key of the mon. user, generate with ceph-authtool
#
# [*id_rsa*]
#   The RSA ssh private key
#
# [*id_rsa_pub*]
#   The RSA ssh public key
#
# [*disks*]
#   Disks which make up any OSDs on the host in the form
#   'sdb:/dev/sdg1' i.e. see the ceph-deploy documentation
#
class ceph::params (
  $deploy_user,
  $deploy_user_is_system = false,
  $fsid,
  $mon_initial_member,
  $mon_host,
  $public_network,
  $cluster_network,
  $monitor_secret,
  $id_rsa,
  $id_rsa_pub,
  $disks = [],
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

}
