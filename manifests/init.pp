# == Class: ovirt
class ovirt (
  $node_service_package       = $ovirt::params::
  $node_service_package_ensure       = $ovirt::params::
  $node_service_name       = $ovirt::params::
  $node_service_ensure       = $ovirt::params::
  $node_service_enabled       = $ovirt::params::
  $node_updateFirewall       = $ovirt::params::
  $engine_service_package       = $ovirt::params::
  $engine_service_package_ensure       = $ovirt::params::
  $engine_service_name       = $ovirt::params::
  $engine_service_ensure       = $ovirt::params::
  $engine_service_enable       = $ovirt::params::
  $engine_setup_conf_d       = $ovirt::params::
  $engine_setup_answers       = $ovirt::params::
  $engine_setup_conf_d_name       = $ovirt::params::
  $engine_application_mode       = $ovirt::params::
  $engine_db_username       = $ovirt::params::
  $engine_db_password       = $ovirt::params::
  $engine_db_hostname       = $ovirt::params::
  $engine_db_dbname        = $ovirt::params::
  $engine_db_port       = $ovirt::params::
  $engine_admin_password       = $ovirt::params::
  $engine_admin_password_filename        = $ovirt::params::
  $engine_iso_domain_name       = $ovirt::params::
  $engine_iso_domain_location       = $ovirt::params::
  $engine_iso_domain_acl       = $ovirt::params::
  $engine_organization       = $ovirt::params::
  $engine_updateFirewall       = $ovirt::params::
  $hosted_engine_fqdn       = $ovirt::params::
  $hosted_engine_mac_address       = $ovirt::params::
  $hosted_engine_gateway       = $ovirt::params::
  $hosted_engine_num_cpu       = $ovirt::params::
  $hosted_engine_mb_ram       = $ovirt::params::
  $hosted_engine_gb_storage       = $ovirt::params::
  $hosted_engine_service_package       = $ovirt::params::
  $hosted_engine_service_package_ensure       = $ovirt::params::
  $hosted_engine_setup_conf_d       = $ovirt::params::
  $hosted_engine_setup_conf_d_name       = $ovirt::params::
  $hosted_engine_services       = $ovirt::params::
  $hosted_engine_service_ensure       = $ovirt::params::
  $hosted_engine_service_enable       = $ovirt::params::

) inherits ovirt::params {


}
