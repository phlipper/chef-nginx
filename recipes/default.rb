#
# Cookbook Name:: nginx
# Recipe:: default
#

include_recipe "nginx::purge_old_versions"

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
