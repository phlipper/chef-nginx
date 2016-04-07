#
# Cookbook Name:: nginx
# Recipe:: default
#

repo = node['nginx']['repository_sources'].fetch(node['nginx']['repository'])

case node['platform_family']
when 'debian'
  apt_repository 'nginx' do
    uri repo['uri']
    distribution repo['distribution']
    components repo['components']
    key repo['key']
    keyserver repo['keyserver'] if repo['keyserver']
    deb_src repo['deb_src']
    action :add
  end
when 'rhel'
  include_recipe 'yum-nginx::default'
else
  fail("Platform family #{node['platform_family']} is not supported.")
end
