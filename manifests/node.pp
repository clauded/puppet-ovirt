# == Class: ovirt::node

class ovirt::node (

  $package_require              = undef,

  $node_service_package         = $ovirt::node_service_package,
  $node_service_package_ensure  = $ovirt::node_service_package_ensure,
  $node_service_name            = $ovirt::node_service_name,
  $node_service_ensure          = $ovirt::node_service_ensure,
  $node_service_enabled         = $ovirt::node_service_enabled,

) inherits ovirt {

  package { $node_service_package:
    ensure  => $node_service_package_ensure,
    require => $package_require,
  }

  # v4 fix 'Sanlock lockspace remove failure', 'Too many open files'
  file_line { 'sanlock_limitnofile':
    path    => '/usr/lib/systemd/system/sanlock.service',
    line    => 'LimitNOFILE=65535',
    require => Package[$node_service_package],
  }
  file_line { 'sanlock_limitnproc':
    path    => '/usr/lib/systemd/system/sanlock.service',
    line    => 'LimitNPROC=65535',
    require => Package[$node_service_package],
  }

  service { $node_service_name:
    ensure  => $node_service_ensure,
    enable  => $node_service_enabled,
    require => Package[$node_service_package],
  }

}
