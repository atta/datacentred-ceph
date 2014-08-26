# == Class: ceph::client
#
# Provision keys for things like cinder and glance
#
define ceph::client (
  $perms = '',
) {

  include ::ceph

  $user = "client.${name}"
  $keyring = "/etc/ceph/ceph.${user}.keyring"

  exec { "echo -n '[${user}]\\n\\tkey = ' > ${keyring}":
    unless => "grep ${user} ${keyring}",
  } ~>

  exec { "ssh -F /home/${ceph::params::deploy_user}/.ssh/config -i /home/${ceph::params::deploy_user}/.ssh/id_rsa ${ceph::params::deploy_user}@${ceph::params::mon_initial_member} sudo \"ceph auth get-or-create-key ${user} ${perms}\" >> ${keyring}":
    refreshonly => true,
  }

#  concat::fragment { "ceph.${user}.conf":
#    target  => '/etc/ceph/ceph.conf',
#    content => template('ceph/ceph.client.conf.erb'),
#    order   => '20',
#  }

}
