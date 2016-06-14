# == Class: ovirt::repo

class ovirt::repo (

  $ovirt_repo_manage       = $ovirt::ovirt_repo_manage,
  $ovirt_repo_package_name = $ovirt::ovirt_repo_package_name,
  $ovirt_repo_version      = $ovirt::ovirt_repo_version,

) inherits ovirt {

  exec { 'yum_repo_ovirt':
    command => "yum -y update && yum -y install ${ovirt_repo_package_name}",
    path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    creates => "/etc/yum.repos.d/ovirt-${ovirt_version}.repo",
    timeout => '600',
  }

}
