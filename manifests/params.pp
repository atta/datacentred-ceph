# == Class: ceph::params
#
# Parameter container class.  Override with hiera
# data bindings
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
  $is_gateway = false,
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

}
