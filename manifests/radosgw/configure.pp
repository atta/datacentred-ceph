# == Class: ceph::radosgw::configure
#
# Configure the rados gateway
#
class ceph::radosgw::configure {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  include ceph::params
  contain ceph::radosgw::configure::apache

  $region = $ceph::params::rados_region
  $zone = "${region}-${ceph::params::rados_zone}"
  $pg_num = $ceph::params::pg_num
  $rgw_pool_size = $ceph::params::rgw_pool_size
  $keystone_url = $ceph::params::keystone_url
  $keystone_admin_token = $ceph::params::keystone_admin_token
  $keystone_accepted_roles = $ceph::params::keystone_accepted_roles
  $rgw_dns_name = $ceph::params::rgw_dns_name

  ceph::pool { [
    ".${region}.rgw.root",
    ".${zone}.domain.rgw",
    ".${zone}.rgw.root",
    ".${zone}.rgw.control",
    ".${zone}.rgw.gc",
    ".${zone}.rgw.buckets.index",
    ".${zone}.rgw.buckets",
    ".${zone}.log",
    ".${zone}.intent-log",
    ".${zone}.usage",
    ".${zone}.users",
    ".${zone}.users.email",
    ".${zone}.users.swift",
    ".${zone}.users.uid",
  ]:
    pg_num => $pg_num,
  }

  ceph::client { "radosgw.${::hostname}":
    perms   => 'mon \"allow rwx\" osd \"allow rwx\"',
    options => [
      "rgw region = ${region}",
      "rgw region root pool = .${region}.rgw.root",
      "rgw zone = ${zone}",
      "rgw zone root pool = .${zone}.rgw.root",
      'rgw enable ops log = true',
      'rgw enable usage log = true',
      "rgw thread pool size = ${rgw_pool_size}",
      "rgw dns name = ${rgw_dns_name}",
      "rgw socket path = /var/run/ceph/ceph.client.radosgw.${::hostname}.fastcgi.sock",
      "host = ${::hostname}",
      "rgw keystone url = ${keystone_url}",
      "rgw keystone admin token = ${keystone_admin_token}",
      "rgw keystone accepted roles = ${keystone_accepted_roles}",
      "rgw relaxed s3 bucket names = true",
    ],
  }

  file { "/var/lib/ceph/radosgw/ceph-radosgw.${::hostname}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Undocumented but the init scripts rely on this file existing
  file { "/var/lib/ceph/radosgw/ceph-radosgw.${::hostname}/done":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
