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
* hosted_engine - *does NOT* install the hosted engine, but *does* pre-seed
                  values for installing the hosted engine.

If you use hosted_engine you can run hosted-engine --deploy to finish
the install.

## Setup

### What ovirt affects

ovirt::node
* installs vdsm

ovirt::engine
* installs ovirt-engine
* runs engine-setup with config options from /etc/ovirt-engine-setup.conf.d/

ovirt::hosted_engine
* installs a sets defaults for the ovirt-hosted-engine

### Setup Requirements **OPTIONAL**

The oVirt packages must be available to your system.
This module will not install the repos.

### Beginning with ovirt

Review the ovirt::params class 

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is targeted at oVirt 3.6 on el7

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.

