# == Class: ovirt
class ovirt (
  $node_service_package       = $ovirt::params::node_service_package,
  $node_service_package_ensure       = $ovirt::params::node_service_package_ensure,
  $node_service_name       = $ovirt::params::node_service_name,
  $node_service_ensure       = $ovirt::params::node_service_ensure,
  $node_service_enabled       = $ovirt::params::node_service_enabled,
  $node_updateFirewall       = $ovirt::params::node_updateFirewall,
  $engine_service_package       = $ovirt::params::engine_service_package,
  $engine_service_package_ensure       = $ovirt::params::engine_service_package_ensure,
  $engine_service_name       = $ovirt::params::engine_service_name,
  $engine_service_ensure       = $ovirt::params::engine_service_ensure,
  $engine_service_enable       = $ovirt::params::engine_service_enable,
  $engine_setup_conf_d       = $ovirt::params::engine_setup_conf_d,
  $engine_setup_answers       = $ovirt::params::engine_setup_answers,
  $engine_setup_conf_d_name       = $ovirt::params::engine_setup_conf_d_name,
  $engine_application_mode       = $ovirt::params::engine_application_mode,
  $engine_db_username       = $ovirt::params::engine_db_username,
  $engine_db_password       = $ovirt::params::engine_db_password,
  $engine_db_hostname       = $ovirt::params::engine_db_hostname,
  $engine_db_dbname        = $ovirt::params::engine_db_dbname,
  $engine_db_port       = $ovirt::params::engine_db_port,
  $engine_admin_password       = $ovirt::params::engine_admin_password,
  $engine_admin_password_filename        = $ovirt::params::engine_admin_password_filename,
  $engine_iso_domain_name       = $ovirt::params::engine_iso_domain_name,
  $engine_iso_domain_location       = $ovirt::params::engine_iso_domain_location,
  $engine_iso_domain_acl       = $ovirt::params::engine_iso_domain_acl,
  $engine_organization       = $ovirt::params::engine_organization,
  $engine_updateFirewall       = $ovirt::params::engine_updateFirewall,
  $hosted_engine_fqdn       = $ovirt::params::hosted_engine_fqdn,
  $hosted_engine_mac_address       = $ovirt::params::hosted_engine_mac_address,
  $hosted_engine_gateway       = $ovirt::params::hosted_engine_gateway,
  $hosted_engine_num_cpu       = $ovirt::params::hosted_engine_num_cpu,
  $hosted_engine_mb_ram       = $ovirt::params::hosted_engine_mb_ram,
  $hosted_engine_gb_storage       = $ovirt::params::hosted_engine_gb_storage,
  $hosted_engine_service_package       = $ovirt::params::hosted_engine_service_package,
  $hosted_engine_service_package_ensure       = $ovirt::params::hosted_engine_service_package_ensure,
  $hosted_engine_setup_conf_d       = $ovirt::params::hosted_engine_setup_conf_d,
  $hosted_engine_setup_conf_d_name       = $ovirt::params::hosted_engine_setup_conf_d_name,
  $hosted_engine_services       = $ovirt::params::hosted_engine_services,
  $hosted_engine_service_ensure       = $ovirt::params::hosted_engine_service_ensure,
  $hosted_engine_service_enable       = $ovirt::params::hosted_engine_service_enable,
) inherits ovirt::params {

  if $node_service_enabled == true {
    include ovirt::node
  }

  if $hosted_engine_service_enable == true {
    include ovirt::hosted_engine
  }

  if $engine_service_enable == true {
    include ovirt::engine
  }

}
