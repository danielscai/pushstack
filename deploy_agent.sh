#!/bin/bash
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb -O puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get install puppet -y
