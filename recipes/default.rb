#
# Cookbook Name:: nginx
# Recipe:: default
#

repo = node["nginx"]["repository_sources"].fetch(node["nginx"]["repository"])

apt_repository "nginx" do
  uri repo["uri"]
  distribution repo["distribution"]
  components repo["components"]
  key repo["key"]
  keyserver repo["keyserver"] if repo["keyserver"]
  deb_src repo["deb_src"]
  action :add
end

template "#{node['nginx']['bin_dir']}/nxensite" do
  source "nxensite.erb"
  owner "root"
  group "root"
  mode "0755"
  not_if { ::File.exists?("#{node['nginx']['bin_dir']}/nxensite") }
end

execute "nxensite #{new_resource.name}" do
  command "ln -s #{node['nginx']['bin_dir']}/nxensite #{node['nginx']['bin_dir']}/nxdissite"
  only_if { ::File.exists?("#{node['nginx']['bin_dir']}/nxensite") }
  not_if { ::File.symlink?("#{node['nginx']['bin_dir']}/nxdissite") }
end
