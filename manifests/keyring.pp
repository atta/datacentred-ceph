# == Class: ceph::keyring
#
# Keyring generation
#
# === Examples
#
# Create a key for a rados gateway:
#
#   ceph::keyring { 'ceph.client.radosgw.gateway-0.keyring':
#     user     => 'client.radosgw.radosgw-0',
#     key      => 'AQAKuexTIAGpIRAAWczOdvoJsrqWGVCv+Ev++Q==',
#     caps_mon => 'allow rwx',
#     caps_psd => 'allow rwx',
#   }
#
define ceph::keyring (
  $user,
  $key,
  $path = '/etc/ceph',
  $caps_mon = undef,
  $caps_mds = undef,
  $caps_osd = undef,
  $owner = 'root',
  $group = 'root',
) {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  file { "${path}/${name}":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => "0644",
    content => template('ceph/keyring.erb'),
  }

}
