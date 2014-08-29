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
  $pg_num = 1024

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
      "rgw dns name = ${::hostname}",
      "rgw socket path = /var/run/ceph/ceph.client.radosgw.${::hostname}.fastcgi.sock",
      "host = ${::hostname}",
    ],
  }

  file { "/var/lib/ceph/radosgw/ceph-radosgw.${hostname}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Undocumented but the init scripts rely on this file existing
  file { "/var/lib/ceph/radosgw/ceph-radosgw.${hostname}/done":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
