#
# Cookbook Name:: nginx
# Provider:: site
#

action :create do
  template "#{node['nginx']['dir']}/sites-available/#{new_resource.name}" do
    source "site.erb"
    owner "root"
    group "root"
    mode "0644"
    variables({
      :name => new_resource.name,
      :listen => new_resource.listen,
      :host => new_resource.host,
      :root => new_resource.root,
      :index => new_resource.index,
      :charset => new_resource.charset,
      :customconfig => new_resource.customconfig,
      :location => new_resource.location,
      :phpfpm => new_resource.phpfpm,
      :accesslog => new_resource.accesslog,
    })
    not_if { ::File.exists?("#{node['nginx']['dir']}/sites-available/#{new_resource.name}")}
  end
end

action :delete do
  file "#{node['nginx']['dir']}/sites-available/#{new_resource.name}" do
    only_if { ::File.exists?("#{node['nginx']['dir']}/sites-available/#{new_resource.name}") }
    action :delete
  end
  file "#{node['nginx']['dir']}/sites-enabled/#{new_resource.name}" do
    only_if { ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.name}") }
    action :delete
  end
end

action :enable do
  execute "nxensite #{new_resource.name}" do
    command "#{node['nginx']['bin_dir']}/nxensite #{new_resource.name}"
    not_if { ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.name}") }
    notifies :restart, "service[nginx]"
    new_resource.updated_by_last_action(true)
  end
end

action :disable do
  execute "nxdissite #{new_resource.name}" do
    command "#{node['nginx']['bin_dir']}/nxdissite #{new_resource.name}"
    only_if { ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.name}") }
    notifies :restart, "service[nginx]"
    new_resource.updated_by_last_action(true)
  end
end
