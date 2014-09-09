# == Class: ceph::config
#
# Main ceph configuration for a node.  This class is floating e.g.
# not contained so that clients reliant on ceph.conf can add extra
# fragments to the configuration, with a subscription to this class
#
class ceph::config {

  include ::ceph::params
  Class['ceph'] -> Class['ceph::config']

  # Create the ceph configuration file for ceph-deploy
  concat { "/etc/ceph/ceph.conf":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Exec is inherited from ::ceph, which plays havoc with concat
  # so restore order here
  Exec {
    user  => 'root',
    group => 'root',
  }

  concat::fragment { 'ceph.conf.erb':
    target  => "/etc/ceph/ceph.conf",
    content => template('ceph/ceph.conf.erb'),
    order   => '10',
  }

}
