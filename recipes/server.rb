#
# Cookbook Name:: nginx
# Recipe:: server
#

include_recipe "nginx"

package node["nginx"]["package_name"] do
  version node["nginx"]["version"]
end

include_recipe "nginx::configuration"
include_recipe "nginx::service"
