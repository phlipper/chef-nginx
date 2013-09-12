#
# Cookbook Name:: nginx
# Recipe:: service
#
# Copyright 2013, Phil Cohen <github@phlippers.net>


service_actions = [:enable]
service_actions << :start unless system("pgrep nginx")

service "nginx" do
  supports status: true, restart: true, reload: true
  action service_actions
end
