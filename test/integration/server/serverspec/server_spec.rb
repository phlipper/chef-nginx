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
  let(:mime_types) do
    file "/etc/nginx/mime.types"
  end

  it "configured the `mime.types` template" do
    expect(mime_types).to be_file
    expect(mime_types).to be_owned_by "root"
    expect(mime_types).to be_grouped_into "root"
    expect(mime_types).to be_mode "644"
  end

  let(:nginx_conf) do
    file "/etc/nginx/nginx.conf"
  end

  it "configured the `nginx.conf` template" do
    expect(nginx_conf).to be_file
    expect(nginx_conf).to be_owned_by "root"
    expect(nginx_conf).to be_grouped_into "root"
    expect(nginx_conf).to be_mode "644"
  end

  let(:status_conf) do
    file "/etc/nginx/conf.d/nginx_status.conf"
  end

  it "configured the `nginx_status.conf` template" do
    expect(status_conf).to be_file
    expect(status_conf).to be_owned_by "root"
    expect(status_conf).to be_grouped_into "root"
    expect(status_conf).to be_mode "644"
  end

  describe "default conf.d templates" do
    let(:default_templates) do
      %w[buffers general gzip logs performance proxy ssl_session timeouts]
    end

    it "configured the templates" do
      default_templates.each do |tmpl|
        conf_file = file("/etc/nginx/conf.d/#{tmpl}.conf")

        expect(conf_file).to be_file
        expect(conf_file).to be_owned_by "root"
        expect(conf_file).to be_grouped_into "root"
        expect(conf_file).to be_mode "644"
      end
    end
  end

  describe "directories" do
    let(:log_dir) do
      file "/var/log/nginx"
    end

    it "configured the log directory" do
      expect(log_dir).to be_directory
      expect(log_dir).to be_owned_by "root"
      expect(log_dir).to be_grouped_into "root"
      expect(log_dir).to be_mode "755"
    end

    let(:sites_available) do
      file "/etc/nginx/sites-available"
    end

    it "configured the sites-available directory" do
      expect(sites_available).to be_directory
      expect(sites_available).to be_owned_by "root"
      expect(sites_available).to be_grouped_into "root"
      expect(sites_available).to be_mode "755"
    end

    let(:sites_enabled) do
      file "/etc/nginx/sites-enabled"
    end

    it "configured the sites-enabled directory" do
      expect(sites_enabled).to be_directory
      expect(sites_enabled).to be_owned_by "root"
      expect(sites_enabled).to be_grouped_into "root"
      expect(sites_enabled).to be_mode "755"
    end
  end

  describe "default-site" do
    let(:default_site) do
      file "/etc/nginx/sites-available/default"
    end

    it "configured the default-site" do
      expect(default_site).to be_file
      expect(default_site).to be_owned_by "root"
      expect(default_site).to be_grouped_into "root"
      expect(default_site).to be_mode "644"
    end
  end
end

describe "nginx::service" do
  it "configured the service" do
    expect(service "nginx").to be_enabled
    expect(service "nginx").to be_running
    expect(port 80).to be_listening
  end
end
