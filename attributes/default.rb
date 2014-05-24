#
# Cookbook Name:: nginx
# Attributes:: default
#
# Author:: Phil Cohen <github@phlippers.net>
#
# Copyright 2013, Phil Cohen
#

default["nginx"]["dir"]        = "/etc/nginx"
default["nginx"]["log_dir"]    = "/var/log/nginx"
default["nginx"]["user"]       = "www-data"
default["nginx"]["binary"]     = "/usr/sbin/nginx"
default["nginx"]["pid_file"]   = "/var/run/nginx.pid"
default["nginx"]["version"]    = nil
default["nginx"]["package_name"] = "nginx"  # nginx[-light|full|extras]

default["nginx"]["log_format"] = <<-FORMAT
  '$remote_addr $host $remote_user [$time_local] "$request" '
  '$status $body_bytes_sent "$http_referer" "$http_user_agent" "$gzip_ratio"'
FORMAT

default["nginx"]["daemon_disable"] = false

default["nginx"]["use_poll"] = true

default["nginx"]["gzip"]              = "on"
default["nginx"]["gzip_http_version"] = "1.0"
default["nginx"]["gzip_buffers"]      = "16 8k"
default["nginx"]["gzip_comp_level"]   = "2"
default["nginx"]["gzip_proxied"]      = "any"
default["nginx"]["gzip_vary"]         = "on"
default["nginx"]["gzip_min_length"]   = "0"
default["nginx"]["gzip_disable"]      = %q|"MSIE [1-6].(?!.*SV1)"|
default["nginx"]["gzip_types"]        = %w[
  text/css text/javascript text/xml text/plain text/x-component
  application/x-javascript application/javascript application/json
  application/xml application/rss+xml image/svg+xml
  font/truetype font/opentype application/vnd.ms-fontobject
]

default["nginx"]["ignore_invalid_headers"]      = "on"
default["nginx"]["recursive_error_pages"]       = "on"
default["nginx"]["sendfile"]                    = "on"
default["nginx"]["server_name_in_redirect"]     = "off"
default["nginx"]["server_tokens"]               = "off"

default["nginx"]["buffers_enable"]              = false
default["nginx"]["client_body_temp_path"]       = "/var/spool/nginx-client-body 1 2"
default["nginx"]["client_body_buffer_size"]     = "8k"
default["nginx"]["client_header_buffer_size"]   = "1k"
default["nginx"]["client_max_body_size"]        = "1m"
default["nginx"]["large_client_header_buffers"] = "4 8k"

default["nginx"]["tcp_nopush"]  = "on"
default["nginx"]["tcp_nodelay"] = "off"

default["nginx"]["proxy_set_headers"] = [
  "X-Real-IP $remote_addr",
  "X-Forwarded-For $proxy_add_x_forwarded_for",
  "Host $http_host"
]
default["nginx"]["proxy_redirect"] = "off"
default["nginx"]["proxy_max_temp_file_size"] = nil
default["nginx"]["proxy_read_timeout"] = nil

default["nginx"]["keepalive"]             = "on"
default["nginx"]["keepalive_timeout"]     = 65
default["nginx"]["send_timeout"]          = 5
default["nginx"]["client_header_timeout"] = 5
default["nginx"]["client_body_timeout"]   = 5

default["nginx"]["worker_processes"]   = node["cpu"]["total"]
default["nginx"]["worker_connections"] = node["cpu"]["total"].to_i * 1024
default["nginx"]["server_names_hash_bucket_size"] = 64

default["nginx"]["conf_files"] = %w[
  buffers general gzip logs performance proxy ssl_session timeouts
]

default["nginx"]["ssl_session_cache_enable"] = true
default["nginx"]["ssl_session_cache"]        = "shared:SSL:10m"
default["nginx"]["ssl_session_timeout"]      = "10m"

default["nginx"]["passenger_enable"]         = false
default["nginx"]["passenger_max_pool_size"]  = 6
default["nginx"]["passenger_pool_idle_time"] = 300

default["nginx"]["enable_stub_status"] = true
default["nginx"]["status_port"]        = 80

default["nginx"]["skip_default_site"]  = false

default["nginx"]["repository"] = "official"
default["nginx"]["repository_sources"] = {
  "official" => {
    "uri"          => "http://nginx.org/packages/#{node["platform"]}",
    "distribution" => node["lsb"]["codename"],
    "components"   => ["nginx"],
    "keyserver"    => nil,
    "key"          => "http://nginx.org/keys/nginx_signing.key",
    "deb_src"      => false
  },

  "ppa" => {
    "uri"          => "http://ppa.launchpad.net/nginx/stable/ubuntu",
    "distribution" => node["lsb"]["codename"],
    "components"   => ["main"],
    "keyserver"    => "keyserver.ubuntu.com",
    "key"          => "C300EE8C",
    "deb_src"      => true
  },

  "phusion" => {
    "uri"          => "https://oss-binaries.phusionpassenger.com/apt/passenger",
    "distribution" => node["lsb"]["codename"],
    "components"   => ["main"],
    "keyserver"    => "keyserver.ubuntu.com",
    "key"          => "561F9B9CAC40B2F7",
    "deb_src"      => true
  }
}
