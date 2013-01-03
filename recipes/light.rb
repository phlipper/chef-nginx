#
# Cookbook Name:: nginx
# Recipe:: light
#
# Copyright 2013, Phil Cohen <github@phlippers.net>

include_recipe "nginx"

package "nginx-light"

include_recipe "nginx::service"
include_recipe "nginx::configuration"
