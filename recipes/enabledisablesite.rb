#
# Cookbook Name:: nginx
# Recipe:: enabledisablesite
#

template "#{node["nginx"]["bin_dir"]}/nxensite" do
  source "nxensite.erb"
  owner "root"
  group "root"
  mode "0755"
end

link "#{node["nginx"]["bin_dir"]}/nxdissite" do
  to "#{node["nginx"]["bin_dir"]}/nxensite"
  only_if { ::File.exist?("#{node["nginx"]["bin_dir"]}/nxensite") }
end

template "/etc/bash_completion.d/nxendissite" do
  source "nxendissite_completion.erb"
  owner "root"
  group "root"
  mode "0644"
end
