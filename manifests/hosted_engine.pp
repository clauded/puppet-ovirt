# == Class: ovirt::hosted_engine

class ovirt::hosted_engine (

  $engine_answers_file                   = $ovirt::engine_answers_file,

  $package_require                       = undef,

  $hosted_engine_setup_conf_d            = $ovirt::hosted_engine_setup_conf_d,
  $hosted_engine_answers_file            = $ovirt::hosted_engine_answers_file,
  $hosted_engine_service_package         = $ovirt::hosted_engine_service_package,
  $hosted_engine_service_package_ensure  = $ovirt::hosted_engine_service_package_ensure,
  $hosted_engine_service_name            = $ovirt::hosted_engine_service_name,
  $hosted_engine_service_ensure          = $ovirt::hosted_engine_service_ensure,
  $hosted_engine_service_enabled         = $ovirt::hosted_engine_service_enabled,
  $hosted_engine_run_engine_setup        = $ovirt::hosted_engine_run_engine_setup,
  $ovirt_engine_appliance_ensure         = $ovirt::ovirt_engine_appliance_ensure,

) inherits ovirt::node {

  package { $hosted_engine_service_package:
    ensure  => $hosted_engine_service_package_ensure,
    require => $package_require,
  }

  file { $hosted_engine_setup_conf_d:
    ensure  => directory,
    owner   => 'root',
    group   => 'kvm',
    mode    => '0750',
    require => Package[$hosted_engine_service_package],
  }

  file { 'hosted_engine_answers_file':
    path    => "${hosted_engine_setup_conf_d}/hosted_engine_answers.conf",
    owner   => 'root',
    group   => 'kvm',
    mode    => '0640',
    source  => $hosted_engine_answers_file,
    require => File[$hosted_engine_setup_conf_d],
  }

  if $hosted_engine_run_engine_setup {

    file { 'engine_answers_file':
      path    => "${hosted_engine_setup_conf_d}/engine_answers.conf",
      owner   => 'root',
      group   => 'kvm',
      mode    => '0640',
      source  => $engine_answers_file,
      before  => Exec['hosted_engine_deploy'],
      require => File[$hosted_engine_setup_conf_d],
    }

    exec { 'install_ovirt_engine_appliance_package':
      command   => "yum -y install ovirt-engine-appliance && touch /etc/puppet/install_ovirt_engine_appliance_package.done",
      path      => '/usr/bin/:/bin/:/sbin:/usr/sbin',
      creates   => '/etc/puppet/install_ovirt_engine_appliance_package.done',
      before    => Exec['hosted_engine_deploy'],
      require   => Package[$hosted_engine_service_package],
    }

  }

  # don't require tty for hosted_engine_deploy to work
  file { 'dont_requiretty':
    path    => '/etc/sudoers.d/01_dont_requiretty',
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => "Defaults    !requiretty\n",
  }

  exec { 'hosted_engine_deploy':
    command   => 'hosted-engine --deploy && touch /etc/puppet/hosted_engine_deploy.done',
    path      => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    logoutput => true,
    timeout   => 1800,
    creates   => '/etc/puppet/hosted_engine_deploy.done',
    notify    => Exec['remove_ovirt_engine_appliance_package'],
    before    => Service[$hosted_engine_service_name],
    require   => [
      File['hosted_engine_answers_file'],
      File['dont_requiretty'],
      Service[$node_service_name],
    ]
  }

  # once deploy is done, this package should be removed if present
  exec { 'remove_ovirt_engine_appliance_package':
    command     => "yum -y remove ovirt-engine-appliance",
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    refreshonly => true,
  }

  # v4 fix ERROR:ovirt_hosted_engine_ha.agent.agent.Agent:Error: '[Errno 24] Too many open files' on Centos 7 with v4+
  exec { 'fix_ovirt_ha_agent_limit':
    command => 'sed -i "/Restart=*/a LimitNPROC=65535\nLimitNOFILE=65535" /usr/lib/systemd/system/ovirt-ha-agent.service',
    path    => [ '/bin', '/usr/bin' ],
    unless  => 'grep -c LimitNPROC /usr/lib/systemd/system/ovirt-ha-agent.service',
    before  => Service[$hosted_engine_service_name],
    require => Package[$hosted_engine_service_package],
  }

  service { $hosted_engine_service_name:
    ensure  => $hosted_engine_service_ensure,
    enable  => $hosted_engine_service_enable,
    require => Package[$hosted_engine_service_package],
  }

}
