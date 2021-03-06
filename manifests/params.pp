# == Class: ovirt::params
class ovirt::params {

  $ovirt_repo_manage                    = true
  $ovirt_repo_url                       = 'http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm'
  $ovirt_repo_version                   = '40'

  $ovirt_engine_appliance_ensure        = 'absent'

  $node_service_package                 = [ 'vdsm', 'vdsm-cli' ]
  $node_service_package_ensure          = 'installed'
  $node_service_name                    = 'vdsmd'
  $node_service_ensure                  = 'running'
  $node_service_enabled                 = true

  $engine_service_package               = 'ovirt-engine'
  $engine_service_package_ensure        = 'installed'
  $engine_service_name                  = 'ovirt-engine'
  $engine_service_ensure                = 'running'
  $engine_service_enabled               = false
  $engine_setup_conf_d                  = '/etc/ovirt-engine-setup.conf.d'
  $engine_answers_file                  = 'puppet:///modules/ovirt/engine_answers.conf'
  $engine_run_engine_setup              = false

  $hosted_engine_service_package        = 'ovirt-hosted-engine-setup'
  $hosted_engine_service_package_ensure = 'installed'
  $hosted_engine_service_name           = [ 'ovirt-ha-agent.service', 'ovirt-ha-broker.service' ]
  $hosted_engine_service_ensure         = 'running'
  $hosted_engine_service_enabled        = false
  $hosted_engine_setup_conf_d           = '/etc/otopi.conf.d'
  $hosted_engine_answers_file           = 'puppet:///modules/ovirt/hosted_engine_answers.conf'
  $hosted_engine_run_engine_setup       = false

}
