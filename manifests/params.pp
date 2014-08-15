class ceph::params (
  $deploy_user,
  $fsid,
  $mon_initial_member,
  $mon_host,
  $public_network,
  $cluster_network,
  $monitor_secret,
  $id_rsa,
  $id_rsa_pub,
  $client_keys = {},
  $disks = [],
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

}
