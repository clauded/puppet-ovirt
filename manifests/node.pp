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

  # run 'vdsm-tool configure --force' to fix service startup
  #exec { 'vdsm_tool_configure':
  #  command => 'vdsm-tool configure --force && touch /etc/puppet/vdsm_tool_configure.done',
  #  path    => [ '/bin', '/usr/bin' ],
  #  creates => '/etc/puppet/vdsm_tool_configure.done',
  #  before  => Service[$node_service_name],
  #  require => Package[$node_service_package],
  #}

  # exclude local disk sda from multipathing
  exec { 'multipath_blacklist':
    command => 'printf "blacklist {\n\tdevnode \"^sda\"\n}\n" >> /etc/multipath.conf && systemctl restart multipathd.service',
    path    => [ '/bin', '/usr/bin' ],
    unless  => 'grep -c blacklist /etc/multipath.conf',
    before  => Service[$node_service_name],
    require => Package[$node_service_package],
  }

  # v4 fix 'Sanlock lockspace remove failure', 'Too many open files'
  exec { 'fix_ovirt_sanlock_limit':
    command => 'sed -i "/ExecStop=*/a LimitNPROC=65535\nLimitNOFILE=65535" /usr/lib/systemd/system/sanlock.service',
    path    => [ '/bin', '/usr/bin' ],
    unless  => 'grep -c LimitNPROC /usr/lib/systemd/system/sanlock.service',
    before  => Service[$node_service_name],
    require => Package[$node_service_package],
  }

  service { $node_service_name:
    ensure  => $node_service_ensure,
    enable  => $node_service_enabled,
    require => Package[$node_service_package],
  }

}
