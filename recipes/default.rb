#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, Phil Cohen <github@phlippers.net>

if node["nginx"]["repository"] == "official"

  apt_repository "nginx" do
    uri "http://nginx.org/packages/#{node["platform"]}"
    distribution node["lsb"]["codename"]
    components ["nginx"]
    action :add
    key "http://nginx.org/keys/nginx_signing.key"
  end

elsif node["nginx"]["repository"] == "ppa"

  apt_repository "nginx" do
    uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
    distribution node["lsb"]["codename"]
    components ["main"]
    action :add
    keyserver "keyserver.ubuntu.com"
    key "C300EE8C"
    deb_src true
  end

end