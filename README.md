# chef-nginx [![Build Status](https://travis-ci.org/phlipper/chef-nginx.png?branch=master)](https://travis-ci.org/phlipper/chef-nginx)

## Description

Installs the [Nginx](http://nginx.org) web server.


## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the
recipes should run on these platforms without error:

* Ubuntu
* Debian

### Cookbooks

* [apt](http://community.opscode.com/cookbooks/apt) Opscode LWRP Cookbook

### Chef

It is recommended to use a version of Chef `>= 10.16.4` as that is the target of my usage and testing, though this should work with most recent versions.

### Ruby

This cookbook requires Ruby 1.9+ and is tested against:

* 1.9.2
* 1.9.3


## Recipes

* `nginx` - The default recipe which sets up the repository.
* `nginx::configuration` - Internal recipe to setup the configuration files.
* `nginx::service` - Internal recipe to setup the service definition.
* `nginx::server` - Install and configure the `nginx` package.
* `nginx::debug` - Install and configure the `nginx-debug` package.


## Usage

This cookbook installs the Nginx components if not present, and pulls updates if they are installed on the system.


## Attributes

```ruby
default["nginx"]["dir"]      = "/etc/nginx"
default["nginx"]["log_dir"]  = "/var/log/nginx"
default["nginx"]["user"]     = "www-data"
default["nginx"]["binary"]   = "/usr/sbin/nginx"
default["nginx"]["pid_file"] = "/var/run/nginx.pid"
default["nginx"]["version"]  = nil

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
  general buffers gzip logs performance proxy timeouts ssl_session
]

default["nginx"]["ssl_session_cache_enable"] = true
default["nginx"]["ssl_session_cache"]        = "shared:SSL:10m"
default["nginx"]["ssl_session_timeout"]      = "10m"

default["nginx"]["passenger_enable"]         = false
default["nginx"]["passenger_max_pool_size"]  = 6
default["nginx"]["passenger_pool_idle_time"] = 300

default["nginx"]["enable_stub_status"] = true
default["nginx"]["status_port"]        = 80
```


## TODO

Including, but not limited to ...

* Fully support all of the standard Chef-supported distributions
* Support additonal build configurations
* Support additonal configuration file attributes
* Provider for creating virtual hosts


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Many thanks go to the following [contributors](https://github.com/phlipper/chef-nginx/graphs/contributors) who have helped to make this cookbook even better:

* **[@jtimberman](https://github.com/jtimberman)**
    * add license file
    * set executable bit for directories
* **[@dwradcliffe](https://github.com/dwradcliffe)**
    * add attribute for nginx status port


## License

**chef-nginx**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2013/license.html).
* Copyright (c) 2013 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)
* http://phlippers.net/
