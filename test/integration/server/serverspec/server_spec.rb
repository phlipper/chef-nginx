# Server recipe is the only one that installs the package. This means I am
# testing everthing in one suite. The aim would be to separate the installation
# so that the tests can also be in their own files.
require "serverspec"
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "nginx::server" do
  it "installed nginx" do
    expect(package "nginx").to be_installed
  end
end

describe "nginx::configuration" do
  describe file("/etc/nginx/mime.types") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "644" }
  end

  describe file("/etc/nginx/nginx.conf") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "644" }
  end

  describe file("/etc/nginx/conf.d/nginx_status.conf") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "644" }
  end

  describe "default conf.d templates" do
    describe file("/etc/nginx/conf.d/buffers.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/general.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/gzip.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/logs.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/performance.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/proxy.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/ssl_session.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end

    describe file("/etc/nginx/conf.d/timeouts.conf") do
      it { should be_a_file }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "644" }
    end
  end

  describe "directories" do
    describe file("/var/log/nginx") do
      it { should be_directory }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "755" }
    end

    describe file("/etc/nginx/sites-available") do
      it { should be_directory }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "755" }
    end

    describe file("/etc/nginx/sites-enabled") do
      it { should be_directory }
      it { should be_owned_by "root" }
      it { should be_grouped_into "root" }
      it { should be_mode "755" }
    end
  end

  describe file("/etc/nginx/sites-available/default") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "644" }
  end
end

describe "nginx::service" do
  it "configured the service" do
    expect(service "nginx").to be_enabled
    expect(service "nginx").to be_running
    expect(port 80).to be_listening
  end
end

describe "nginx::enabledisablesite" do
  describe file("/usr/sbin/nxensite") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "755" }
  end

  describe file("/usr/sbin/nxdissite") do
    it { should be_linked_to "/usr/sbin/nxensite" }
  end

  describe file("/etc/bash_completion.d/nxendissite") do
    it { should be_a_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into "root" }
    it { should be_mode "644" }
  end
end
