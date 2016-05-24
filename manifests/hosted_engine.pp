# == Class: ovirt::hosted_engine
class ovirt::hosted_engine (

  $engine_answers_file                  = $ovirt::engine_answers_file,

  $hosted_engine_setup_conf_d           = $ovirt::hosted_engine_setup_conf_d,
  $hosted_engine_answers_file           = $ovirt::hosted_engine_answers_file,
  $hosted_engine_service_package        = $ovirt::hosted_engine_service_package,
  $hosted_engine_service_package_ensure = $ovirt::hosted_engine_service_package_ensure,
  $hosted_engine_service_name           = $ovirt::hosted_engine_service_name,
  $hosted_engine_service_ensure         = $ovirt::hosted_engine_service_ensure,
  $hosted_engine_service_enabled        = $ovirt::hosted_engine_service_enabled,
  $hosted_engine_run_engine_setup       = $ovirt::hosted_engine_run_engine_setup,


) inherits ovirt::node {

  package { $hosted_engine_service_package:
    ensure => $hosted_engine_service_package_ensure,
    notify => Exec['hosted_engine_deploy'],
  }

  file { $hosted_engine_setup_conf_d:
    ensure  => directory,
    owner   => 'root',
    group   => 'kvm',
    mode    => '0640',
    require => Package[$hosted_engine_service_package],
  }

  file { 'hosted_engine_answers_file':
    path    => "${hosted_engine_setup_conf_d}/hosted_engine_answers.conf",
    owner   => 'root',
    group   => 'kvm',
    mode    => '0600',
    source  => $hosted_engine_answers_file,
    before  => Exec['hosted_engine_deploy'],
    require => File[$hosted_engine_setup_conf_d],
  }

  if $hosted_engine_run_engine_setup {
    file { 'engine_answers_file':
      path    => "${hosted_engine_setup_conf_d}/engine_answers.conf",
      owner   => 'root',
      group   => 'kvm',
      mode    => '0600',
      source  => $engine_answers_file,
      before  => Exec['hosted_engine_deploy'],
      require => File[$hosted_engine_setup_conf_d],
    }
  }

  # This is configured to automatically run ovirt-hosted-engine-setup
  # if you've set ensure=>latest on the hosted-engine.
  exec { 'hosted_engine_deploy':
    # TODO: pre-install ovirt-engine-appliance-3.6-20160420.1.el7.centos.noarch.rpm
    command      => 'hosted-engine --deploy',
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    logoutput   => true,
    timeout     => 1850,
    refreshonly => true,
    before      => Service[$hosted_engine_services],
  }

  service { $hosted_engine_service_name:
    ensure  => $hosted_engine_service_ensure,
    enable  => $hosted_engine_service_enable,
    require => Package[$hosted_engine_service_package],
  }

}
