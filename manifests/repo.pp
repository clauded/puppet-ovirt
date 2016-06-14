# == Class: ovirt::repo

class ovirt::repo (

  $ovirt_repo_manage       = $ovirt::ovirt_repo_manage,
  $ovirt_repo_package_name = $ovirt::ovirt_repo_package_name,
  $ovirt_repo_version      = $ovirt::ovirt_repo_version,

) inherits ovirt {

  exec { 'yum_update':
    command => "yum -y update && touch /etc/puppet/yum_update.done",
    path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    creates => "/etc/puppet/yum_update.done",
    timeout => '300',
    before  => Package["$ovirt_repo_package_name"],
  }
  package { "$ovirt_repo_package_name":
    ensure => present,
  }

}
