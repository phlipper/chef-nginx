#
# Cookbook Name:: nginx
# Recipe:: debug
#

include_recipe "nginx"

package "nginx-debug"

include_recipe "nginx::configuration"
include_recipe "nginx::service"
