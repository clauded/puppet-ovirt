# == Class: ovirt::engine
class ovirt::engine (
  $engine_service_package         = $ovirt::engine_service_package,
  $engine_service_package_ensure  = $ovirt::engine_service_package_ensure,
  $engine_service_name            = $ovirt::engine_service_name,
  $engine_service_ensure          = $ovirt::engine_service_ensure,
  $engine_service_enable          = $ovirt::engine_service_enable,
  $engine_application_mode        = $ovirt::engine_application_mode,
  $engine_db_username             = $ovirt::engine_db_username,
  $engine_db_password             = $ovirt::engine_db_password,
  $engine_db_dbname               = $ovirt::engine_db_dbname,
  $engine_db_hostname             = $ovirt::engine_db_hostname,
  $engine_db_port                 = $ovirt::engine_db_port,
  $engine_organization            = $ovirt::engine_organization,
  $engine_updateFirewall          = $ovirt::engine_updateFirewall,
  $engine_admin_password          = $ovirt::engine_admin_password,
  $engine_admin_password_filename = $ovirt::engine_admin_password_filename,
  $engine_iso_domain_acl          = $ovirt::engine_iso_domain_acl,
  $engine_iso_domain_name         = $ovirt::engine_iso_domain_name,
  $engine_iso_domain_location     = $ovirt::engine_iso_domain_location,
  $engine_setup_conf_d            = $ovirt::engine_setup_conf_d,
  $engine_setup_conf_d_name       = $ovirt::engine_setup_conf_d_name,
  $engine_setup_answers           = $ovirt::engine_setup_answers,
) inherits ovirt {

  $conf               = "${engine_setup_conf_d}/${engine_setup_conf_d_name}"
  $ovirtadminpassfile = "${engine_setup_conf_d}/${engine_admin_password_filename}"

  package { $engine_service_package:
    ensure => $engine_service_package_ensure,
    notify => Exec['run engine-setup'],
  }

  file { 'engine pre-seed answers':
    path    => $conf,
    owner   => 'root',
    group   => 'kvm',
    mode    => '0640',
    content => template('ovirt/etc/ovirt-engine-setup.conf.d/answers.erb'),
    require => Package[$engine_service_package],
  }

  if $engine_admin_password {
    file { 'ovirt-admin-password':
      path    => $ovirtadminpassfile,
      owner   => 'root',
      group   => 'kvm',
      mode    => '0640',
      content => "[environment:default]\nOVESETUP_CONFIG/adminPassword=str:${engine_admin_password}\n",
      require => Package[$engine_service_package],
    }
  } else {
    fail('engine_admin_password cannot be undefined')
  }

  service { $engine_service_name:
    ensure  => $engine_service_ensure,
    enable  => $engine_service_enable,
    require => Package[$engine_service_package],
  }

  # This is configured to automatically run engine-setup
  # if you've set ensure=> latest on th engine, thus
  # performing your post install update step
  exec { 'run engine-setup':
    command     => 'engine-setup',
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    logoutput   => true,
    timeout     => 1850,
    refreshonly => true,
    before      => Service[$engine_service_name],
    require     => [
      File['engine pre-seed answers'],
      File['ovirt-admin-password'],
    ],
  }
}
