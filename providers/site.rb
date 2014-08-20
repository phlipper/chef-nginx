#
# Cookbook Name:: nginx
# Provider:: site
#

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  template nginx_available_file do
    source new_resource.templatesource
    cookbook new_resource.templatecookbook
    owner "root"
    group "root"
    mode "0644"
    variables(
      name: new_resource.name,
      listen: new_resource.listen,
      host: new_resource.host,
      root: new_resource.root,
      index: new_resource.index,
      slashlocation: new_resource.slashlocation,
      phpfpm: new_resource.phpfpm,
      access_log: new_resource.access_log
    )
  end
end

action :delete do
  if @current_resource.exists
    nginx_site new_resource.name do
      action :disable
    end

    file nginx_available_file do
      action :delete
    end
  else
    log_missing_resource
  end
end

action :enable do
  if @current_resource.exists
    execute "nxensite #{new_resource.name}" do
      command "#{node["nginx"]["bin_dir"]}/nxensite #{new_resource.name}"
      not_if { ::File.exist?(nginx_enabled_file) }
    end
  else
    log_missing_resource
  end
end

action :disable do
  if @current_resource.exists
    execute "nxdissite #{new_resource.name}" do
      command "#{node["nginx"]["bin_dir"]}/nxdissite #{new_resource.name}"
      only_if { ::File.exist?(nginx_enabled_file) }
    end
  else
    log_missing_resource
  end
end

def load_current_resource
  @current_resource = Chef::Resource::NginxSite.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  @current_resource.exists = ::File.exist?(nginx_available_file)
end

def nginx_available_file
  "#{node["nginx"]["dir"]}/sites-available/#{new_resource.name}"
end

def nginx_enabled_file
  "#{node["nginx"]["dir"]}/sites-enabled/#{new_resource.name}"
end

def log_missing_resource
  Chef::Log.info "#{@new_resource} doesn't exist - nothing to do."
end
