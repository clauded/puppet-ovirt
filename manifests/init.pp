# == Class: ovirt

class ovirt (

  $ovirt_repo_manage                    = $ovirt::ovirt_repo_manage,
  $ovirt_repo_url                       = $ovirt::ovirt_repo_url,
  $ovirt_repo_version                   = $ovirt::ovirt_repo_version,

  $package_require                      = undef, # when not managing repo

  #$ovirt_engine_appliance_package_name  = $ovirt::ovirt_engine_appliance_package_name,
  #$ovirt_engine_appliance_file          = $ovirt::ovirt_engine_appliance_file,
  $ovirt_engine_appliance_ensure        = $ovirt::ovirt_engine_appliance_ensure,

  $disable_firewalld                    = $ovirt::ovirt_disable_firewalld,
  $disable_networkmanager               = $ovirt::ovirt_disable_networkmanager,

  $node_service_package                 = $ovirt::node_service_package,
  $node_service_package_ensure          = $ovirt::node_service_package_ensure,
  $node_service_name                    = $ovirt::node_service_name,
  $node_service_ensure                  = $ovirt::node_service_ensure,
  $node_service_enabled                 = $ovirt::node_service_enabled,

  $disable_firewalld                    = $ovirt::disable_firewalld,
  $disable_networkmanager               = $ovirt::disable_networkmanager,

  $engine_answers_file                  = $ovirt::engine_answers_file,
  $engine_setup_conf_d                  = $ovirt::engine_setup_conf_d,
  $engine_service_package               = $ovirt::engine_service_package,
  $engine_service_package_ensure        = $ovirt::engine_service_package_ensure,
  $engine_service_name                  = $ovirt::engine_service_name,
  $engine_service_ensure                = $ovirt::engine_service_ensure,
  $engine_service_enabled               = $ovirt::engine_service_enabled,
  $engine_run_engine_setup              = $ovirt::engine_run_engine_setup,

  $hosted_engine_setup_conf_d           = $ovirt::hosted_engine_setup_conf_d,
  $hosted_engine_answers_file           = $ovirt::hosted_engine_answers_file,
  $hosted_engine_service_package        = $ovirt::hosted_engine_service_package,
  $hosted_engine_service_package_ensure = $ovirt::hosted_engine_service_package_ensure,
  $hosted_engine_service_name           = $ovirt::hosted_engine_service_name,
  $hosted_engine_service_ensure         = $ovirt::hosted_engine_service_ensure,
  $hosted_engine_service_enabled        = $ovirt::hosted_engine_service_enabled,
  $hosted_engine_run_deploy             = $ovirt::hosted_engine_run_deploy,
  $hosted_engine_run_engine_setup       = $ovirt::hosted_engine_run_engine_setup,

) inherits ovirt::params {

  if $disable_firewalld {
    service { 'firewalld':
      ensure => stopped,
      enable => false,
    }
  }

  if $disable_networkmanager {
    service { 'NetworkManager':
      ensure => stopped,
      enable => false,
    }->
    service { 'network':
      ensure => running,
      enable => true,
    }
  }

  if $ovirt_repo_manage {
    $package_require_supp = "Package[ovirt-release${ovirt_repo_version}]"
    class { 'ovirt::repo':
    }
  } else {
    $package_require_supp = $package_require
  }

  if $node_service_enabled {
    class { 'ovirt::node':
      package_require => $package_require_supp,
    }
  }

  if $engine_service_enabled {
    class { 'ovirt::engine':
      package_require => $package_require_supp,
    }
  }

  if $hosted_engine_service_enabled {
    class { 'ovirt::hosted_engine':
      package_require => [ Package[$node_service_package], $package_require_supp ],
    }
  }

}
