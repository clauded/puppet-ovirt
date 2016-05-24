# == Class: ovirt::params
class ovirt::params {

  $ovirt_repo_manage       = false
  $ovirt_repo_package_name = "http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm"
  $ovirt_version           = '3.6'

  $node_service_package        = 'vdsm'
  $node_service_package_ensure = 'installed'
  $node_service_name           = 'vdsmd'
  $node_service_ensure         = 'running'
  $node_service_enabled        = true

  $engine_service_package        = 'ovirt-engine'
  $engine_service_package_ensure = 'installed'
  $engine_service_name           = 'ovirt-engine'
  $engine_service_ensure         = 'running'
  $engine_service_enable         = false
  $engine_setup_conf_d           = '/etc/ovirt-engine-setup.conf.d'
  $engine_answers_file           = ""

  $hosted_engine_service_package        = 'ovirt-hosted-engine-setup'
  $hosted_engine_service_package_ensure = 'installed'
  $hosted_engine_service_name           = ['ovirt-ha-agent.service', 'ovirt-ha-broker.service']
  $hosted_engine_service_ensure         = 'running'
  $hosted_engine_service_enable         = false
  $hosted_engine_setup_conf_d           = '/etc/otopi.conf.d'
  $hosted_engine_answers_file           = ""
  $hosted_engine_run_engine_setup       = true

}
