# == Class: ceph::client_key
#
# Adds client keys to a monitor node.  Should only be run on the
# primary monitor node
#
# === Parameters
#
# [*name*]
#   Name of the user
#
# [*context*]
#   What type of client, eg client, client.rados
#
# [*caps_mon*]
#   Monitor capabilities granted to the user
#
# [*caps_mds*]
#   Metadata server capabilities granted to the user
#
# [*caps_osd*]
#   OSD capabilities grated to the user
#
# === Examples
#
# Create a cinder client:
#
#   ceph::client_key { 'cinder':
#     caps_mon => 'allow *',
#     caps_osd => 'allow *',
#   }
#
# Create a gateway client:
#
#   ceph::client_key { 'radosgw-0':
#     context  => 'client.radosgw',
#     caps_mon => 'allow *',
#     caps_osd => 'allow *',
#   }
#
define ceph::client_key (
  $key,
  $context = 'client',
  $caps_mon = undef,
  $caps_mds = undef,
  $caps_osd = undef,
) {

  include ::ceph::params

  ceph::keyring { "ceph.${context}.${name}.keyring":
    user     => "${context}.${name}",
    key      => $key,
    caps_mon => $caps_mon,
    caps_mds => $caps_mds,
    caps_osd => $caps_osd,
    path     => "/home/${ceph::params::deploy_user}",
    owner    => $ceph::params::deploy_user,
    group    => $ceph::params::deploy_user,
  } ~>
  
  exec { "ceph auth import -i ceph.${context}.${name}.keyring":
    cwd         => "/home/${ceph::params::deploy_user}",
    refreshonly => true,
  }

}
