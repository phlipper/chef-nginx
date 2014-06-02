#
# Cookbook Name:: nginx
# Resource:: site
#

actions :create, :delete, :enable, :disable

default_action :create if defined?(default_action) # Chef > 10.8

# Default action for Chef <= 10.8
def initialize(*args)
  super
  @action = :create
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :listen, :kind_of => String, :default => '80'
attribute :host, :kind_of => String, :default => 'localhost'
attribute :root, :kind_of => String, :default => '/var/www'
attribute :index, :kind_of => String, :default => 'index.html index.htm'
attribute :charset, :kind_of => String, :default => 'utf-8'
attribute :customconfig, :kind_of => String, :default => nil
attribute :slashlocation, :kind_of => String, :default => 'try_files $uri $uri/'
attribute :phpfpm, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :accesslog, :kind_of => [ TrueClass, FalseClass ], :default => true
attr_accessor :exists
