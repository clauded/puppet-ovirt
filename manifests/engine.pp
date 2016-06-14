# == Class: ovirt::engine

class ovirt::engine (

  $package_require                = $ovirt::package_require

  $engine_answers_file            = $ovirt::engine_answers_file,
  $engine_setup_conf_d            = $ovirt::engine_setup_conf_d,
  $engine_service_package         = $ovirt::engine_service_package,
  $engine_service_package_ensure  = $ovirt::engine_service_package_ensure,
  $engine_service_name            = $ovirt::engine_service_name,
  $engine_service_ensure          = $ovirt::engine_service_ensure,
  $engine_service_enabled         = $ovirt::engine_service_enabled,
  $engine_run_engine_setup        = $ovirt::engine_run_engine_setup,

) inherits ovirt {

  package { $engine_service_package:
    ensure  => $engine_service_package_ensure,
    require => $package_require,
  }

  if $engine_run_engine_setup {
    file { $engine_setup_conf_d:
      ensure  => directory,
      owner   => 'root',
      group   => 'kvm',
      mode    => '0750',
      require => Package[$engine_service_package],
    }

    file { 'engine_answers_file':
      path    => "${engine_setup_conf_d}/engine_answers.conf",
      owner   => 'root',
      group   => 'kvm',
      mode    => '0640',
      source  => $engine_answers_file,
      require => File[$engine_setup_conf_d],
    }

    exec { 'engine_setup':
      command     => 'engine-setup && touch /etc/puppet/engine_setup.done',
      path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      logoutput   => true,
      timeout     => 1800,
      creates     => '/etc/puppet/engine_setup.done',
      before      => Service[$engine_service_name],
      require     => File['engine_answers_file'],
    }
  }

  service { $engine_service_name:
    ensure  => $engine_service_ensure,
    enable  => $engine_service_enable,
    require => Package[$engine_service_package],
  }

}
