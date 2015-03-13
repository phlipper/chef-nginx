name             "nginx"
maintainer       "Phil Cohen"
maintainer_email "github@phlippers.net"
license          "MIT"
description      "Installs/configures nginx"
long_description "Please refer to README.md"
version          "0.6.1"

recipe "nginx", "The default recipe which sets up the repository."
recipe "nginx::configuration", "Internal recipe to setup the configuration files."
recipe "nginx::service", "Internal recipe to setup the service definition."
recipe "nginx::server", "Install and configure the `nginx` package."
recipe "nginx::debug", "Install and configure the `nginx-debug` package."

depends "apt"

supports "debian"
supports "ubuntu"
