# == Class: ceph
#
# Base ceph install for all node types.  Installs the cephdeploy
# user, password-less SSH, sudo rights, then installs and configures
# ceph on node
#
class ceph {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  include ::ceph::params

  # Create the ceph deploy user
  user { $ceph::params::deploy_user:
    ensure     => present,
    comment    => 'Ceph Deploy',
    managehome => true,
    password   => '!',
  } ->

  # Enable key based SSH access
  file { "/home/${ceph::params::deploy_user}/.ssh":
    ensure => directory,
    owner  => $ceph::params::deploy_user,
    group  => $ceph::params::deploy_user,
    mode   => '0750',
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/id_rsa":
    ensure  => file,
    owner   => $ceph::params::deploy_user,
    group   => $ceph::params::deploy_user,
    mode    => '0400',
    content => $ceph::params::id_rsa,
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/id_rsa.pub":
    ensure  => file,
    owner   => $ceph::params::deploy_user,
    group   => $ceph::params::deploy_user,
    mode    => '0644',
    content => template('ceph/id_rsa.pub.erb'),
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/config":
    ensure  => file,
    owner   => $ceph::params::deploy_user,
    group   => $ceph::params::deploy_user,
    mode    => '0644',
    content => template('ceph/config.erb'),
  } ->

  ssh_authorized_key { $ceph::params::deploy_user:
    ensure => present,
    key    => $ceph::params::id_rsa_pub,
    type   => 'ssh-rsa',
    user   => $ceph::params::deploy_user,
  } ->

  # Enable passwordless sudo
  file { "/etc/sudoers.d/${ceph::params::deploy_user}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => "${ceph::params::deploy_user} ALL=(all) NOPASSWD:ALL",
  } ->

  # Install ceph deploy and ceph
  package { 'ceph-deploy':
    ensure => 'present',
  } ->

  exec { "ceph-deploy install --no-adjust-repos ${::hostname}":
    cwd    => "/home/${ceph::params::deploy_user}",
    unless => 'dpkg -l | grep ceph-common',
  } ->

  # Create the ceph configuration file for ceph-deploy
  file { "/home/${ceph::params::deploy_user}/ceph.conf":
    ensure  => file,
    owner   => $ceph::params::deploy_user,
    group   => $ceph::params::deploy_user,
    mode    => '0644',
    content => template('ceph/ceph.conf.erb'),
  }

}
