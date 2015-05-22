#
# Cookbook Name:: nginx
# Recipe:: server
#

include_recipe "nginx"

package node["nginx"]["package_name"] do
  version node["nginx"]["version"]
  
  # ensure config files don't get trampled by chef
  options %(-o Dpkg::Options::="--force-confdef")
  only_if { %w[ppa phusion].include?(node["nginx"]["repository"]) }
end

include_recipe "nginx::service"
include_recipe "nginx::configuration"
include_recipe "nginx::enabledisablesite"
