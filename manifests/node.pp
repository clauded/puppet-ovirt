# == Class: ovirt::node
class ovirt::node (
  $node_service_package        = $ovirt::node_service_package,
  $node_service_package_ensure = $ovirt::node_service_package_ensure,
  $node_service_name           = $ovirt::node_service_name,
  $node_service_ensure         = $ovirt::node_service_ensure,
  $node_service_enabled        = $ovirt::node_service_enabled,
) inherits ovirt {

  package { $node_service_package:
    ensure  => $node_service_package_ensure,
  }

  service { $node_service_name:
    ensure  => $node_service_ensure,
    enable  => $node_service_enabled,
    require => Package[$node_service_package],
  }

}
