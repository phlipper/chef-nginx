#
# Cookbook Name:: nginx
# Recipe:: service
#
# Copyright 2013, Phil Cohen <github@phlippers.net>


service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
