# ovirt

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ovirt](#setup)
    * [What ovirt affects](#what-ovirt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ovirt](#beginning-with-ovirt)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module will install the oVirt services and and setup the engine.

## Module Description

This module includes a few specific classes:

* node - for installing the oVirt services onto compute nodes
* engine - for installing the oVirt engine onto your management engine
* hosted_engine - for installing the oVirt hosted engine

You can choose to install manually the hosted-engine and/or the engine
after the deployment of the packages. You can override the default
configuration files with your own specific files.

## Setup

### What ovirt affects

ovirt::node
* installs vdsm

ovirt::engine
* installs ovirt-engine
* optionally, runs engine-setup with config options from files located
  in /etc/ovirt-engine-setup.conf.d/

ovirt::hosted_engine
* installs ovirt-hosted-engine
* optionally, runs hosted-engine --deploy with config options from files
  located in /etc/otopi.conf.d/
* optionally, runs engine-setup with config options from files located
  in the same directory

### Setup Requirements **OPTIONAL**

The oVirt packages must be available to your system or
this module can optionally install the ovirt repos.

### Beginning with ovirt

Review the ovirt::params class to see all options available

## Usage

Deploying ovirt hosted engine with the engine appliance and running
engine-setup with specific answers file:

  class { 'ovirt':
    ovirt_repo_manage              => true,
    hosted_engine_service_enabled  => true,
    hosted_engine_run_deploy       => true,
    hosted_engine_run_engine_setup => true,
    ovirt_engine_appliance_ensure  => 'installed',
    hosted_engine_answers_file     => "puppet:///modules/${module_name}/ovirt/hosted_engine_answers.conf",
    engine_answers_file            => "puppet:///modules/${module_name}/ovirt/engine_answers.conf",
  }

Deploying ovirt engine and running engine-setup with specific answers file:

  class { 'ovirt':
    engine_service_enabled     => true,
    engine_run_engine_setup    => true,
    hosted_engine_answers_file => "puppet:///modules/${module_name}/ovirt/hosted_engine_answers.conf",
    engine_answers_file        => "puppet:///modules/${module_name}/ovirt/engine_answers.conf",
  }

Deploying ovirt node:

  class { 'ovirt':
    node_service_enabled => true,
  }

## Reference

TODO

## Limitations

This module has been tested with oVirt 3.6 on centos7 running Puppet 3.8

## Development

Log requests ans issues on Github.

## Release Notes/Contributors/Etc **Optional**

This module is based on https://github.com/jcpunk/puppet-ovirt

