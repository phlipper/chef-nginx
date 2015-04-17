#
# Cookbook Name:: nginx
# Recipe:: configuration
#

[node["nginx"]["dir"], node["nginx"]["log_dir"]].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode "0755"
    recursive true
  end
end

cookbook_file "#{node["nginx"]["dir"]}/mime.types" do
  source "mime.types"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, "service[nginx]"
  not_if { node["nginx"]["skip_default_mime_types"] }
end

template "nginx.conf" do
  path "#{node["nginx"]["dir"]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, "service[nginx]"
end

%w[sites-available sites-enabled].each do |vhost_dir|
  directory "#{node["nginx"]["dir"]}/#{vhost_dir}" do
    owner  "root"
    group  "root"
    mode   "0755"
    action :create
  end
end

nginx_site "default" do
  host node["hostname"]
  root "/var/www/nginx-default"
  not_if { node["nginx"]["skip_default_site"] }
end

# ensure default site is removed if necessary
%w[enabled available].each do |dir|
  file "#{node["nginx"]["dir"]}/sites-#{dir}/default" do
    action :delete
    only_if { node["nginx"]["skip_default_site"] }
    notifies :restart, "service[nginx]"
  end
end

node["nginx"]["conf_files"].each do |config_file|
  template config_file do
    path "#{node["nginx"]["dir"]}/conf.d/#{config_file}.conf"
    source "#{config_file}.conf.erb"
    owner "root"
    group "root"
    mode  "0644"
    notifies :restart, "service[nginx]"
  end
end

template "#{node["nginx"]["dir"]}/conf.d/nginx_status.conf" do
  source "nginx_status.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]"
  variables(port: node["nginx"]["status_port"])
  only_if { node["nginx"]["enable_stub_status"] }
end

template "#{node["nginx"]["dir"]}/conf.d/passenger.conf" do
  source "passenger.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, "service[nginx]"
  only_if { node["nginx"]["passenger_enable"] }
end
