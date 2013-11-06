#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, Phil Cohen <github@phlippers.net>


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
