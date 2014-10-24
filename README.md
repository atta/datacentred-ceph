#datacentred-ceph

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
   * [Hiera Configuration](#hiera-configuration)
   * [Ceph Monitor](#ceph-monitor)
   * [Ceph OSD](#ceph-osd)
   * [RADOS Gateway](#rados-gateway)
4. [Dependencies](#dependencies)

## Overview

Installs a ceph cluster

## Module Description

Using cephdeploy as a basis this module sets up a ceph deploy user on all nodes, which performs all the requisite ssh and sudo operations and installs the software.  You then specifiy the node type which will provision monitors, osds and gateways

## Usage

Obviously you want to provision in a set order.  Primary monitor first which automatically generates the admin and bootstrap keys, followed by optional monitors.  Next add your disks to the array.  At this point take some time to create your storage pools.  Finally roll out your object storage gateways.

### Hiera Configuration

This is a shared set of code so should probably live in hiera/common/%{calling_module}/ceph.yaml depending on your puppet configuration.  The fsid field can be generated with uuidgen, monitor_secret with something like 'ceph-authtool temp -C -g', and the SSH IDs with ssh-keygen.

    ---
    ceph::params::deploy_user: 'ceph-deploy'
    ceph::params::fsid: '6baccb3c-075c-11e4-8a7d-3c970ebb2b86'
    ceph::params::mon_initial_member: 'melody'
    ceph::params::mon_host: '192.168.0.1'
    ceph::params::public_network: '192.168.0.0/24'
    ceph::params::cluster_network: '192.168.16.0/24'
    ceph::params::monitor_secret: 'AQAfQr1TWISSBBAApIfGtQlLn59r5GieKvDjog=='
    ceph::params::id_rsa: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIEowIBAAKCAQEA5DMaV020tkcazSxZZ1R3H3v6SQrCr7Gepzwue2D6k1NRCoQ4
      H82IdW+cju+DaS09YoAUx3TkvkJNODf98tP1bqWmKoBr49j4kSKqE8GjYq6XegM2
      Nx3OFNb8+RdrAeyXdRQEVG/PFcD0+RKlGAVIMM36GsVbsEc30xXG0MQt1+YoHcmy
      iygCoDwnDpZQIHscLyngYMZzgpqXwwePSjphSrxaNU/QVhEVy5C5ny12A7Mcbf2u
      5twH+ugA/XDxoUEmSsXakrtyb4f4rT1f88cOrwQqbe4GfTDWjucHVO5Y3drVabdE
      4hxUD3uNiqvK69KSKHyTFwJ7FWoGypHgtptovQIDAQABAoIBAFeEOb/trzaQwniZ
      X5g/TogmlfBZThzvc7cTX4g1wyOpOlVcK+IWgxT2vwYaWT2G+hnCoTV1YRyOdOrw
      nlX4cBIFOVrncXkqhvmyX6PACZcY+kLy5GHy7kwTv2UQVBuizts52AdB8huXqtuz
      CNnTfMIq3JZTxjwus/wiR+NcuXAovR1mMzOCPcu1xQmyXe6FaL9wXh7B5QL33Xv/
      GxNxHurlNtAeJN0J/aAgpJ6PiKopULnWAxOI03FFSY0ghZqEwHctfewaEBXj3xQ8
      eGl8njxp1n+shimU/ayWZ1mH7IPxdrhF99O3+kb6nq+u4iJmR6ryPlrXjzfHEWEZ
      W14HXQkCgYEA90WuWH6S5a/G3jeJ6Rm7jIdkmjf7CcdnLZft5ek9mVdwBjHLp1oW
      +lZjfjUsvahyotGnnp14mAS/NFkj2Hfqp0BBA1A+6rQRBlsIDMMc0W6EmAPYxsjp
      tqgjK74gsRnMhb2XCfFFTWcR2hWSlt64B6hTQh8NdcuqjmhYU8wZQvsCgYEA7EEV
      qYTGpD4i8CakrZTxeiKYYZuVfmtRZVy85wPueiI7Lc4NsZ6hFH1c7tPzKTv2ZdGj
      myOFJB67CHd22dvX+8W07NYnlP6BYw1W1A5pQlrBa+XtWBZFIscrTSgyfYnbUPqR
      H89faJyB2AUapslyr1GNytDTXhIh+MJEBCxMdacCgYAobJHWEcs+FYBzb6zyGKza
      in/d3m0B6kFp6L6RqZHSccL0oEtk7ot3HYxiY5sO3mzvRUsb2S6P26bOjgwYJXKN
      KSn3urSudgWafmNQgs1BR8oRd/+Gb+4VWGN3kTuS+F7BNn9stq7XupPmjURLudlo
      FxKVarIuob8eTNyzxlgS5QKBgHr97w8PRnJevsWS+Iw9S/EvbXDzFEJ6ECfavaTu
      kQoYJALWkJ51XJpUITtcL+y5gK7FEo1DUp7ZOLlRqBgGsUwrQuNBId4ZGLa+TQOc
      dQPMR4Gqc4M2JMvUMCC82nwsdnaT21VaGetV/uq8zYEiwoeux0hcqo0Al5rvV4Vs
      omllAoGBAIIybikURPN+l0HiVFmV2PLbQrb7zvtJJIQcTr7YVt4vOiZuHrXUtC1T
      ROoe2ZR7i14GwS9ZrwTl78LAQFlM8VKoU7uWSVU88ej2eONgELiO57IZS9Ojdwux
      YZqsfM9HbuMY2NjYv8PhZISfe3pNH+FRJy5vNoZ41up8GJjHDa+w
      -----END RSA PRIVATE KEY-----
    ceph::params::id_rsa_pub: 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDkMxpXTbS2RxrNL...
    ceph::params::disks:
       - 'sdb:/dev/sdd1'
       - 'sdc:/dev/sdd2'
    ceph::params::rados_region: 'uk'
    ceph::params::rados_zone: 'northwest'
    ceph::params::pg_num: 1024
    ceph::params::osd_location_hook: '/usr/local/bin/location_hook.py'

### Ceph monitor

Simply a matter of creating a profile with the following

    include ceph::mon

### Ceph OSD

Again simply a matter of the following

    include ceph::osd

### RADOS gateway

Notice the pattern yet?

    include ceph::radosgw

## Dependencies

This modules requires the following third party modules

* puppetlabs-apache
* puppetlabs-concat

