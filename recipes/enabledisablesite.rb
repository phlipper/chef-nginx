#
# Cookbook Name:: nginx
# Recipe:: nxendissite
#

template "#{node["nginx"]["bin_dir"]}/nxensite" do
  source "nxensite.erb"
  owner "root"
  group "root"
  mode "0755"
  not_if { ::File.exist?("#{node["nginx"]["bin_dir"]}/nxensite") }
end

execute "Link #{node["nginx"]["bin_dir"]}/nxdissite" do
  command "ln -s #{node["nginx"]["bin_dir"]}/nxensite \
    #{node["nginx"]["bin_dir"]}/nxdissite"
  only_if { ::File.exist?("#{node["nginx"]["bin_dir"]}/nxensite") }
  not_if { ::File.symlink?("#{node["nginx"]["bin_dir"]}/nxdissite") }
end

template "/etc/bash_completion.d/nxendissite" do
  source "nxendissite_completion.erb"
  owner "root"
  group "root"
  mode "0644"
  not_if { ::File.exist?("/etc/bash_completion.d/nxendissite") }
end
