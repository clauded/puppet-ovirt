# == Class: ovirt::hosted_engine
class ovirt::hosted_engine (
  $engine_admin_password                = $ovirt::engine_admin_password,
  $engine_admin_password_filename       = $ovirt::engine_admin_password_filename,
  $hosted_engine_fqdn                   = $ovirt::hosted_engine_fqdn,
  $hosted_engine_service_package        = $ovirt::hosted_engine_service_package,
  $hosted_engine_service_package_ensure = $ovirt::hosted_engine_service_package_ensure,
  $hosted_engine_setup_conf_d           = $ovirt::hosted_engine_setup_conf_d,
  $hosted_engine_setup_conf_d_name      = $ovirt::hosted_engine_setup_conf_d_name,
  $hosted_engine_services               = $ovirt::hosted_engine_services,
  $hosted_engine_service_ensure         = $ovirt::hosted_engine_service_ensure,
  $hosted_engine_service_enable         = $ovirt::hosted_engine_service_enable,
  $hosted_engine_mac_address            = $ovirt::hosted_engine_mac_address,
  $hosted_engine_gateway                = $ovirt::hosted_engine_gateway,
  $hosted_engine_num_cpu                = $ovirt::hosted_engine_num_cpu,
  $hosted_engine_mb_ram                 = $ovirt::hosted_engine_mb_ram,
  $hosted_engine_gb_storage             = $ovirt::hosted_engine_gb_storage,
) inherits ovirt::node {

  $conf               = "${hosted_engine_setup_conf_d}/${hosted_engine_setup_conf_d_name}"
  $ovirtadminpassfile = "${hosted_engine_setup_conf_d}/${engine_admin_password_filename}"

  package { $hosted_engine_service_package:
    ensure => $hosted_engine_service_package_ensure,
    #notify => Exec['run hosted-engine-deploy'],
  }

  #file { $hosted_engine_setup_conf_d:
  #  ensure  => directory,
  #  require => Package[$hosted_engine_service_package],
  #}

  #file { 'hosted pre-seed answers':
  #  path    => $conf,
  #  owner   => 'root',
  #  group   => 'kvm',
  #  mode    => '0600',
  #  content => template('ovirt/etc/otopi.conf.d/hosted-engine.erb'),
  #  before  => Service[$ovirt::node::node_service_name],
  #  require => [
  #    Package[$hosted_engine_service_package],
  #    File[$hosted_engine_setup_conf_d],
  #  ],
  #}

  if $engine_admin_password {
    file { 'ovirt-admin-password':
      path    => $ovirtadminpassfile,
      owner   => 'root',
      group   => 'kvm',
      mode    => '0640',
      content => "[environment:default]\nOVESETUP_CONFIG/adminPassword=str:${engine_admin_password}\n",
      require => Package[$hosted_engine_service_package],
    }
  } else {
    fail('engine_admin_password cannot be undefined')
  }

  #service { $hosted_engine_services:
  #  ensure  => $hosted_engine_service_ensure,
  #  enable  => $hosted_engine_service_enable,
  #  require => Package[$hosted_engine_service_package],
  #}

  # This is configured to automatically run ovirt-hosted-engine-setup
  # if you've set ensure=> latest on th engine, thus
  # performing your post install update step
  exec { 'run hosted-engine-deploy':
   # TODO: installer au prealable ovirt-engine-appliance-3.6-20160420.1.el7.centos.noarch.rpm
   command     => 'hosted-engine --deploy',
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    logoutput   => true,
    timeout     => 1850,
    refreshonly => true,
    #before      => Service[$hosted_engine_services],
    require     => [
      File['hosted pre-seed answers'],
      File['ovirt-admin-password'],
    ],
  }
}
