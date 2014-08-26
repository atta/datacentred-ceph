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

  File {
    owner  => $ceph::params::deploy_user,
    group  => $ceph::params::deploy_user,
  }

  Exec {
    user        => $ceph::params::deploy_user,
    environment => "USER=${ceph::params::deploy_user}",
    cwd         => "/home/${ceph::params::deploy_user}",
  }

  # Create the ceph deploy user
  user { $ceph::params::deploy_user:
    ensure     => present,
    comment    => 'Ceph Deploy',
    managehome => true,
    password   => '!',
    system     => $ceph::params::deploy_user_is_system,
  } ->

  # Enable key based SSH access
  file { "/home/${ceph::params::deploy_user}/.ssh":
    ensure => directory,
    mode   => '0750',
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/id_rsa":
    ensure  => file,
    mode    => '0400',
    content => $ceph::params::id_rsa,
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/id_rsa.pub":
    ensure  => file,
    mode    => '0644',
    content => template('ceph/id_rsa.pub.erb'),
  } ->

  file { "/home/${ceph::params::deploy_user}/.ssh/config":
    ensure  => file,
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
    content => "${ceph::params::deploy_user} ALL=(root) NOPASSWD:ALL",
  } ->

  # Create the ceph configuration file for ceph-deploy
  file { "/home/${ceph::params::deploy_user}/ceph.conf":
    ensure  => file,
    mode    => '0644',
    content => template('ceph/ceph.conf.erb'),
  } ->

  # Install ceph deploy and ceph
  package { 'ceph-deploy':
    ensure => 'present',
  } ->

  exec { "ceph-deploy install --no-adjust-repos ${::hostname}":
    unless => 'dpkg -l | grep ceph-common',
  }

}
