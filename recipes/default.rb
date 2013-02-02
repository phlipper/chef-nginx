#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, Phil Cohen <github@phlippers.net>

apt_repository "nginx" do
  uri "http://nginx.org/packages/#{node["platform"]}"
  distribution node["lsb"]["codename"]
  components ["nginx"]
  action :add
  key "http://nginx.org/keys/nginx_signing.key"
end
