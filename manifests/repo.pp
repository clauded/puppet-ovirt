# == Class: ovirt::repo

class ovirt::repo (

  $ovirt_repo_manage  = $ovirt::ovirt_repo_manage,
  $ovirt_repo_url     = $ovirt::ovirt_repo_url,
  $ovirt_repo_version = $ovirt::ovirt_repo_version,

) inherits ovirt {

  exec { 'yum_update':
    command => "yum -y update && touch /etc/puppet/yum_update.done",
    path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    creates => "/etc/puppet/yum_update.done",
    timeout => '600',
    before  => Package["ovirt-release${ovirt_repo_version}"],
  }
  package { "ovirt-release${ovirt_repo_version}":
    ensure => present,
    source => $ovirt_repo_url
  }

}
