#
# Cookbook Name:: nginx
# Provider:: site
#

def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("Create configuration file for #{@new_resource}") do
      template "#{node["nginx"]["dir"]}/sites-available/#{@new_resource.name}" do
        source @new_resource.templatesource
        cookbook @new_resource.templatecookbook
        owner "root"
        group "root"
        mode "0644"
        variables(
          name: @new_resource.name,
          listen: @new_resource.listen,
          host: @new_resource.host,
          root: @new_resource.root,
          index: @new_resource.index,
          slashlocation: @new_resource.slashlocation,
          phpfpm: @new_resource.phpfpm,
          accesslog: @new_resource.accesslog
        )
        not_if do
          ::File.exist?(
            "#{node["nginx"]["dir"]}/sites-available/#{@new_resource.name}"
          )
        end
      end
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Disable and remove configuration file for #{@new_resource}") do
      nginx_site @new_resource.name do
        action :disable
      end
      file "#{node["nginx"]["dir"]}/sites-available/#{@new_resource.name}" do
        only_if do
          ::File.exist?(
            "#{node["nginx"]["dir"]}/sites-available/#{@new_resource.name}"
          )
        end
        action :delete
      end
    end
  else
    Chef::Log.info "#{@new_resource} doesn't exists - nothing to do."
  end
end

action :enable do
  converge_by("Enable #{@new_resource} configuration and restart nginx") do
    execute "nxensite #{@new_resource.name}" do
      command "#{node["nginx"]["bin_dir"]}/nxensite #{@new_resource.name}"
      not_if do
        ::File.symlink?(
          "#{node["nginx"]["dir"]}/sites-enabled/#{@new_resource.name}"
        )
      end
      notifies :reload, "service[nginx]"
    end
  end
end

action :disable do
  converge_by("Disable #{@new_resource} if enabled and restart nginx") do
    execute "nxdissite #{@new_resource.name}" do
      command "#{node["nginx"]["bin_dir"]}/nxdissite #{@new_resource.name}"
      only_if do
        ::File.symlink?(
          "#{node["nginx"]["dir"]}/sites-enabled/#{@new_resource.name}"
        )
      end
      notifies :reload, "service[nginx]"
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::NginxSite.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  @current_resource.exists = ::File.exist?(
    "#{node["nginx"]["dir"]}/sites-available/#{new_resource.name}"
  )
end
