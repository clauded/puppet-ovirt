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
  $ovirt_engine_appliance_package_name  = $ovirt::ovirt_engine_appliance_package_name,
  $ovirt_engine_appliance_file          = $ovirt::ovirt_engine_appliance_file,
  $ovirt_engine_appliance_ensure        = $ovirt::ovirt_engine_appliance_ensure,


) inherits ovirt::node {

  package { $hosted_engine_service_package:
    ensure => $hosted_engine_service_package_ensure,
    notify => Exec['hosted_engine_deploy'],
  }

  if $ovirt_engine_appliance_ensure == 'installed' {
    exec { 'wget_ovirt_engine_appliance_package':
      command   => "wget $ovirt_engine_appliance_package_name -O ${ovirt_engine_appliance_file}",
      path      => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      logoutput => true,
      timeout   => 1800,
      creates   => $ovirt_engine_appliance_file,
      before    => Exec['install_ovirt_engine_appliance_package'],
    }
    exec { 'install_ovirt_engine_appliance_package':
      command   => "rpm -i ${ovirt_engine_appliance_file} && touch /etc/puppet/install_ovirt_engine_appliance_package.done",
      path      => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      logoutput => true,
      creates   => '/etc/puppet/install_ovirt_engine_appliance_package.done',
      before    => Exec['hosted_engine_deploy'],
      require   => Package[$hosted_engine_service_package],
    }
  }

  file { $hosted_engine_setup_conf_d:
    ensure  => directory,
    owner   => 'root',
    group   => 'kvm',
    mode    => '0600',
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

  exec { 'hosted_engine_deploy':
    command     => 'hosted-engine --deploy',
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    logoutput   => true,
    timeout     => 1800,
    refreshonly => true,
    before      => Service[$hosted_engine_service_name],
  }

  service { $hosted_engine_service_name:
    ensure  => $hosted_engine_service_ensure,
    enable  => $hosted_engine_service_enable,
    require => Package[$hosted_engine_service_package],
  }

}
