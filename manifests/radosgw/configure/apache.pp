# == Class: ceph::radosgw::configure::apache
#
# Configure the apache server expose an https session and
# interface with the rados gateway with fastCGI
#
class ceph::radosgw::configure::apache {

  if $caller_module_name != $module_name {
    fail("${name} is private")
  }

  include ::apache
  include ::apache::mod::fastcgi

  Class['::apache'] ->

  file { '/var/www/s3gw.fcgi':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    content => template('ceph/s3gw.fcgi.erb'),
  }

  apache::vhost { $::fqdn:
    port           => 443,
    ssl            => true,
    ssl_cert       => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key        => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    docroot        => '/var/www',
    rewrites       => [
      { rewrite_rule => ['^/(.*) /s3gw.fcgi?%{QUERY_STRING} [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]'] },
    ],
    fastcgi_server => '/var/www/s3gw.fcgi',
    fastcgi_socket => "/var/run/ceph/ceph.radosgw.${::hostname}.fastcgi.sock",
    fastcgi_dir    => '/var/www',
  }

}
