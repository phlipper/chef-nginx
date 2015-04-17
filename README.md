# chef-nginx [![Build Status](http://img.shields.io/travis-ci/phlipper/chef-nginx.png)](https://travis-ci.org/phlipper/chef-nginx)

## Description

Installs the [Nginx](http://nginx.org) web server.


## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the
recipes should run on these platforms without error:

* Ubuntu 12.04+
* Debian 6.0.8+

### Cookbooks

* [apt](http://community.opscode.com/cookbooks/apt) Opscode LWRP Cookbook

### Chef

* Chef 11+

### Ruby

This cookbook requires Ruby 1.9+ and is tested against:

* 2.0.0
* 2.1.2


## Recipes

* `nginx` - The default recipe which sets up the repository.
* `nginx::configuration` - Internal recipe to setup the configuration files.
* `nginx::service` - Internal recipe to setup the service definition.
* `nginx::server` - Install and configure the `nginx` package.
* `nginx::debug` - Install and configure the `nginx-debug` package.
* `nginx::enabledisablesite` - Install enable and disable scripts for nginx sites.


## Resources and Providers

This cookbook provides one resource with a corresponding provider

### site.rb
Manage virtual hosts - create, delete, enable and disable virtual host configurations

Actions:

* `create` - Create a virtual host configuration file.
* `delete` - Delete a virtual host configuration file.
* `enable` - Enable a virtual host configuration file.
* `disable` - Disable a virtual host configuration file.

Attribute Parameters (only used with the `create` action):

* `listen` - the ip address and/or port to [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen) to, defaults to '80'
* `host` - [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) for the virtualhost, defaults to 'localhost'
* `root` - the path to the site [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root) folder, defaults to '/var/www'
* `index` - the [index](http://nginx.org/en/docs/http/ngx_http_index_module.html) files, in order of use, defaults to 'index.html index.htm'
* `location` - basic [location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) block configuration, defaults to 'try_files $uri $uri/'
* `phpfpm` - inserts a basic php fpm handler for .php files if true, defaults to false
* `access_log` - enable or disable the access log, defaults to true
* `custom_data` - hash of extra data for any custom things you might throw into your override template, defaults to an empty hash
* `template_cookbook` - allows you to override the template used with your own. Set this to your cookbook name and create a template named 'site.erb', defaults to 'nginx'
* `template_source` - override for the name of the template from the default 'site.erb'


## Usage

This cookbook installs the Nginx components if not present, and pulls updates if they are installed on the system.
It also installs a nxensite and nxdissite script for enabling and disabling sites and provides a provider for creating and enabling/disabling nginx-sites.

### nginx_site

Create a nginx virtual host configuration file in the sites-available folder

```ruby
nginx_site "example.com" do
  host "example.com www.example.com"
  root "/var/www/example.com"
end
```

This would create a configuration file for example.com and www.example.com that points to `/var/www/example.com`

```ruby
nginx_site "example.com" do
  action :enable
end
```

This would enable a previously created site named `example.com`

```ruby
nginx_site "example.com" do
  host "example.com www.example.com"
  root "/var/www/example.com"
  index "index.php index.html index.htm"
  location "try_files $uri $uri/ /index.php?$query_string"
  phpfpm true
  action [:create, :enable]
end
```

This would create a php-fpm enabled virtual host (provided you have php-fpm installed) with a default rewrite to index.php and enable it

```ruby
my_data = { 'env' => 'production' }

nginx_site "example.com" do
  host "example.com www.example.com"
  root "/var/www/example.com"
  custom_data my_data
  template_cookbook 'my_cookbook'
  template_source 'my.conf.erb'
  action [:create, :enable]
end
```

This would create a virtual host using your own custom template ´my.conf.erb´ in the cookbook ´my_cookbook´. The contents of ´my_data´ will be available in the template, thus writing ´@custom_data['environment']´ in your template will yield ´production´ in this example. And as with the previous examples `:enable` will make the site enabled.


## Attributes

```ruby
default["nginx"]["dir"]        = "/etc/nginx"
default["nginx"]["log_dir"]    = "/var/log/nginx"
default["nginx"]["user"]       = "www-data"
default['nginx']["bin_dir"]    = "/usr/sbin"
default["nginx"]["binary"]     = "/usr/sbin/nginx"
default["nginx"]["pid_file"]   = "/var/run/nginx.pid"
default["nginx"]["purge_old"]  = false # purges all installed versions of nginx via apt-get purge
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
  general buffers gzip logs performance proxy timeouts ssl_session
]

default["nginx"]["ssl_session_cache_enable"] = true
default["nginx"]["ssl_session_cache"]        = "shared:SSL:10m"
default["nginx"]["ssl_session_timeout"]      = "10m"

default["nginx"]["passenger_enable"]         = false
default["nginx"]["passenger_ruby"]           = nil # if nil, uses `which ruby`
default["nginx"]["passenger_config"]         = {
  "passenger_pool_idle_time" => 300,
  "passenger_max_pool_size"  => 6
}
default["nginx"]["passenger_headers"]        = {
  # "X-Forwarded-For" => "$http_x_forwarded_for"
}
default["nginx"]["passenger_prestart_urls"]  = [
  # "http://myawesomeapp.com:81/"
]

default["nginx"]["enable_stub_status"] = true
default["nginx"]["status_port"]        = 80

default["nginx"]["skip_default_site"]  = false

default["nginx"]["skip_default_mime_types"] = false

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
    "deb_src"      => true,
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
```


## TODO

Including, but not limited to ...

* Fully support all of the standard Chef-supported distributions
* Support additonal build configurations
* Support additonal configuration file attributes


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
    * add attribute for nginx version
    * add option to use PPA repository instead of official nginx repository
    * make sure log directory exists
    * use correct path for `mime.types` file
* **[@0rca](https://github.com/0rca)**
    * add `skip_default_site` attribute
* **[@RichardWigley](https://github.com/RichardWigley)**
    * add initial `test-kitchen` support
* **[@arvidbjorkstrom](https://github.com/arvidbjorkstrom)**
    * Provider for creating/deleting hosts configurations, enabling and disabling them
    * add `custom_data` attribute to the `site` LWRP
* **[@perusio](https://github.com/perusio)**
    * Script for enabling and disabling sites, added and renamed by [@arvidbjorkstrom](https://github.com/arvidbjorkstrom)
* **[@morr](https://github.com/morr)**
    * update `mime.types` to support web fonts correctly


## License

**chef-nginx**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2012-2014/license.html).
* Copyright (c) 2012-2014 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper) [![Gittip](http://img.shields.io/gittip/phlipper.png)](https://www.gittip.com/phlipper/)
* http://phlippers.net/
