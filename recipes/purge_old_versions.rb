#
# Cookbook Name:: nginx
# Recipe:: purge_old_versions
#

return unless node["nginx"]["purge_old"]

package_list = [
  "nginx",
  "nginx-light",
  "nginx-naxsi",
  "nginx-common",
  "passenger",
  "nginx-extras",
  "passenger-enterprise",
  "nginx-full"
]

package_list.each do |pkg|
  apt_package pkg do
    action :purge
    only_if { node["nginx"]["purge_old"] && Mixlib::ShellOut.new("dpkg-query -W -f='${Status}' #{pkg} 2>/dev/null | grep -c 'ok installed'").run_command.stdout.to_i != 0 }
  end
end
