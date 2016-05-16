# == Class: ovirt::params
class ovirt::params {
  $node_service_package        = 'vdsm'
  $node_service_package_ensure = 'installed'

  $node_service_name    = 'vdsmd'
  $node_service_ensure  = 'running'
  $node_service_enabled = true
  $node_updateFirewall  = true

  $engine_service_package        = 'ovirt-engine'
  $engine_service_package_ensure = 'installed'

  $engine_service_name   = 'ovirt-engine'
  $engine_service_ensure = 'running'
  $engine_service_enable = false

  $engine_setup_conf_d      = '/etc/ovirt-engine-setup.conf.d'
  $engine_setup_answers     = '/var/lib/ovirt-engine/setup/answers/*.conf'
  $engine_setup_conf_d_name = '999-puppet.conf'
  $engine_application_mode  = 'both'

  $engine_db_username = 'engine'
  $engine_db_password = $::uuid
  $engine_db_hostname = 'localhost'
  $engine_db_dbname   = 'engine'
  $engine_db_port     = '5432'

  $engine_admin_password          = undef
  $engine_admin_password_filename = '888-adminpass.conf'

  $engine_iso_domain_name     = 'ISO_DOMAIN'
  $engine_iso_domain_location = '/var/lib/exports/iso'
  if $::domain {
    $engine_iso_domain_acl    = "${::fqdn}(rw) *.${::domain}(ro,insecure)"
  } else {
    $engine_iso_domain_acl    = "${::fqdn}(rw) *(ro,insecure)"
  }

  if $::organization {
    $engine_organization = $::organization
  } elsif $::domain {
    $engine_organization = $::domain
  } else {
    $engine_organization = 'localdomain'
  }
  $engine_updateFirewall = true

  $hosted_engine_fqdn        = undef
  $hosted_engine_mac_address = undef
  $hosted_engine_gateway     = undef
  $hosted_engine_num_cpu     = '2'
  $hosted_engine_mb_ram      = '4096'
  $hosted_engine_gb_storage  = '50'

  $hosted_engine_service_package        = 'ovirt-hosted-engine-setup'
  $hosted_engine_service_package_ensure = 'installed'
  $hosted_engine_setup_conf_d           = '/etc/otopi.conf.d'
  $hosted_engine_setup_conf_d_name      = '999-puppet-hosted-engine.conf'
  $hosted_engine_services               = ['ovirt-ha-agent.service', 'ovirt-ha-broker.service']
  $hosted_engine_service_ensure         = 'running'
  $hosted_engine_service_enable         = true
}
