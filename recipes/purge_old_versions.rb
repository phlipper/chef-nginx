#
# Cookbook Name:: nginx
# Recipe:: purge_old_versions
#

%w(nginx nginx-light nginx-naxsi nginx-common passenger nginx-extras passenger-enterprise nginx-full).each do |pkg|
  apt_package pkg do
    action :purge
    only_if { node['nginx']['purge_old'] }
  end
end
