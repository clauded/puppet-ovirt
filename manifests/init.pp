# == Class: ovirt

class ovirt (

  $ovirt_repo_manage                     = $ovirt::ovirt_repo_manage,
  $ovirt_repo_package_name               = $ovirt::ovirt_repo_package_name,
  $ovirt_version                         = $ovirt::ovirt_version,
  $ovirt_engine_appliance_package_name   = $ovirt::ovirt_engine_appliance_package_name,
  $ovirt_engine_appliance_file           = $ovirt::ovirt_engine_appliance_file,
  $ovirt_engine_appliance_ensure         = $ovirt::ovirt_engine_appliance_ensure,

  $node_service_package                  = $ovirt::node_service_package,
  $node_service_package_ensure           = $ovirt::node_service_package_ensure,
  $node_service_package_require          = undef,
  $node_service_name                     = $ovirt::node_service_name,
  $node_service_ensure                   = $ovirt::node_service_ensure,
  $node_service_enabled                  = $ovirt::node_service_enabled,

  $engine_answers_file                   = $ovirt::engine_answers_file,
  $engine_setup_conf_d                   = $ovirt::engine_setup_conf_d,
  $engine_service_package                = $ovirt::engine_service_package,
  $engine_service_package_ensure         = $ovirt::engine_service_package_ensure,
  $engine_service_package_require        = undef,
  $engine_service_name                   = $ovirt::engine_service_name,
  $engine_service_ensure                 = $ovirt::engine_service_ensure,
  $engine_service_enabled                = $ovirt::engine_service_enabled,
  $engine_run_engine_setup               = $ovirt::engine_run_engine_setup,

  $hosted_engine_setup_conf_d            = $ovirt::hosted_engine_setup_conf_d,
  $hosted_engine_answers_file            = $ovirt::hosted_engine_answers_file,
  $hosted_engine_service_package         = $ovirt::hosted_engine_service_package,
  $hosted_engine_service_package_ensure  = $ovirt::hosted_engine_service_package_ensure,
  $hosted_engine_service_package_require = undef,
  $hosted_engine_service_name            = $ovirt::hosted_engine_service_name,
  $hosted_engine_service_ensure          = $ovirt::hosted_engine_service_ensure,
  $hosted_engine_service_enabled         = $ovirt::hosted_engine_service_enabled,
  $hosted_engine_run_deploy              = $ovirt::hosted_engine_run_deploy,
  $hosted_engine_run_engine_setup        = $ovirt::hosted_engine_run_engine_setup,

) inherits ovirt::params {

  if $ovirt_repo_manage {
    class { 'ovirt::repo':
    }
  }

  if $node_service_enabled == true {
    class { 'ovirt::node':
      node_service_package_require => $node_service_package_require,
    }
  }

  if $engine_service_enabled == true {
    class { 'ovirt::engine':
      hosted_engine_service_package_require => $hosted_engine_service_package_require,
    }
  }

  if $hosted_engine_service_enabled == true {
    class { 'ovirt::hosted_engine':
      engine_service_package_require => $engine_service_package_require,
    }
  }

}
