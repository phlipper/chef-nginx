#
# Cookbook Name:: nginx
# Recipe:: purge_old_versions
#

package_list = [
  "nginx",
  "nginx-light",
  "nginx-naxsi",
  "nginx-common",
  "passenger",
  "nginx-extras",
  "passenger-enterprise",
  "nginx-full"
]

package_list.each do |pkg|
  apt_package pkg do
    action :purge
    only_if { node["nginx"]["purge_old"] }
  end
end
