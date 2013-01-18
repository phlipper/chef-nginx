#
# Cookbook Name:: nginx
# Recipe:: debug
#
# Copyright 2013, Phil Cohen <github@phlippers.net>

include_recipe "nginx"

package "nginx-debug"

include_recipe "nginx::service"
include_recipe "nginx::configuration"
