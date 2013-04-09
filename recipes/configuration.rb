#
# Cookbook Name:: nginx
# Recipe:: configuration
#
# Copyright 2013, Phil Cohen <github@phlippers.net>

template "nginx.conf" do
  path "#{node["nginx"]["dir"]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode  "0644"
end

%w[sites-available sites-enabled].each do |vhost_dir|
  directory "#{node["nginx"]["dir"]}/#{vhost_dir}" do
    owner  "root"
    group  "root"
    mode   "0755"
    action :create
  end
end

template "#{node["nginx"]["dir"]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode  "0644"
end

for config_file in node["nginx"]["conf_files"]
  template config_file do
    path "#{node["nginx"]["dir"]}/conf.d/#{config_file}.conf"
    source "#{config_file}.conf.erb"
    owner "root"
    group "root"
    mode  "0644"
    notifies :restart, "service[nginx]", :immediately
  end
end

template "#{node["nginx"]["dir"]}/conf.d/nginx_status.conf" do
  source "nginx_status.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]", :immediately
  variables( :port => node["nginx"]["status_port"] )
  only_if { node["nginx"]["enable_stub_status"] }
end
