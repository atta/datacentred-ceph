# == Class: ceph::client
#
# Provision keys for things like radosgw, cinder and glance
#
# == Parameters
#
# [*perms*]
#   The permissions to grant the client, these must be escaped due to
#   macro expansion e.g. 'osd \"allow rwx\" mon \"allow rwx\"'
#
# [*options*]
#   By default this class will add the user and keyfile to ceph.conf
#   you can add other options to those stanzas with this array
#
define ceph::client (
  $perms = '',
  $options = [],
) {

  include ::ceph

  $user = "client.${name}"
  $keyring = "/etc/ceph/ceph.${user}.keyring"

  exec { "echo -n '[${user}]\\n\\tkey = ' > ${keyring}":
    unless => "grep ${user} ${keyring}",
    path   => '/bin:/usr/bin',
  } ~>

  exec { "ssh -F /home/${ceph::params::deploy_user}/.ssh/config -i /home/${ceph::params::deploy_user}/.ssh/id_rsa ${ceph::params::deploy_user}@${ceph::params::mon_initial_member} sudo \"ceph auth get-or-create-key ${user} ${perms}\" >> ${keyring}":
    refreshonly => true,
    path        => '/bin:/usr/bin',
  }

  # Exec is inherited from ::ceph, which plays havoc with concat
  # so restore order here
  Exec {
    user  => 'root',
    group => 'root',
  }

  concat::fragment { "ceph.${user}.conf":
    target  => '/etc/ceph/ceph.conf',
    content => template('ceph/ceph.client.conf.erb'),
    order   => '20',
  }

}
