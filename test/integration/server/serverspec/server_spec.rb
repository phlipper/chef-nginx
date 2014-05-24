# Server recipe is the only one that installs the package. This means I am
# testing everthing in one suite. The aim would be to separate the installation
# so that the tests can also be in their own files.
require "serverspec"
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "chef-nginx::server" do
  it "has installed nginx" do
    expect(package "nginx").to be_installed
  end

  describe "chef-nginx::configuration" do
    describe "mime.types" do
      let(:mime_types) do
        file "/etc/nginx/mime.types"
      end

      it "is included" do
        expect(mime_types).to be_file
      end

      it "is owned" do
        expect(mime_types).to be_owned_by "root"
      end

      it "is grouped" do
        expect(mime_types).to be_grouped_into "root"
      end

      it "has mode set" do
        expect(mime_types).to be_mode 644
      end
    end

    describe "nginx_conf" do
      let(:nginx_conf) do
        file "/etc/nginx/nginx.conf"
      end

      it "is included" do
        expect(nginx_conf).to be_file
      end

      it "is owned" do
        expect(nginx_conf).to be_owned_by "root"
      end

      it "is grouped" do
        expect(nginx_conf).to be_grouped_into "root"
      end

      it "has mode set" do
        expect(nginx_conf).to be_mode 644
      end
    end

    describe "config files" do
      describe "buffers" do
        let(:buffers_conf) do
          file "/etc/nginx/conf.d/buffers.conf"
        end

        it "is included" do
          expect(buffers_conf).to be_file
        end

        it "is owned" do
          expect(buffers_conf).to be_owned_by "root"
        end

        it "is grouped" do
          expect(buffers_conf).to be_grouped_into "root"
        end

        it "has mode set" do
          expect(buffers_conf).to be_mode 644
        end
      end

      it "general is included" do
        expect(file "/etc/nginx/conf.d/general.conf").to be_file
      end

      it "gzip is included" do
        expect(file "/etc/nginx/conf.d/gzip.conf").to be_file
      end

      it "logs is included" do
        expect(file "/etc/nginx/conf.d/logs.conf").to be_file
      end

      it "performance is included" do
        expect(file "/etc/nginx/conf.d/performance.conf").to be_file
      end

      it "proxy is included" do
        expect(file "/etc/nginx/conf.d/proxy.conf").to be_file
      end

      it "ssl_session is included" do
        expect(file "/etc/nginx/conf.d/ssl_session.conf").to be_file
      end

      it "timeouts is included" do
        expect(file "/etc/nginx/conf.d/timeouts.conf").to be_file
      end
    end

    describe "nginx_conf" do
      let(:nginx_conf) { file "/etc/nginx/conf.d/nginx_status.conf" }

      it "is included" do
        expect(nginx_conf).to be_file
      end

      it "is owned" do
        expect(nginx_conf).to be_owned_by "root"
      end

      it "is grouped" do
        expect(nginx_conf).to be_grouped_into "root"
      end

      it "has mode set" do
        expect(nginx_conf).to be_mode 644
      end
    end

    describe "directories" do
      describe "log" do
        let(:log_file) { file "/var/log/nginx" }

        it "is included" do
          expect(log_file).to be_directory
        end

        it "is owned" do
          expect(log_file).to be_owned_by "root"
        end

        it "is grouped" do
          expect(log_file).to be_grouped_into "root"
        end

        it "has mode set" do
          expect(log_file).to be_mode 755
        end
      end

      describe "sites-available" do
        let(:sites_available) { file "/etc/nginx/sites-available" }
        it "is included" do
          expect(sites_available).to be_directory
        end

        it "is owned" do
          expect(sites_available).to be_owned_by "root"
        end

        it "is grouped" do
          expect(sites_available).to be_grouped_into "root"
        end

        it "has mode set" do
          expect(sites_available).to be_mode 755
        end
      end

      describe "sites-enabled" do
        it "is included" do
          expect(file "/etc/nginx/sites-enabled").to be_directory
        end
      end

      describe "default-site" do
        let(:default_site) { file "/etc/nginx/sites-available/default" }
        it "is included" do
          expect(default_site).to be_file
        end

        it "is owned" do
          expect(default_site).to be_owned_by "root"
        end

        it "is grouped" do
          expect(default_site).to be_grouped_into "root"
        end

        it "has mode set" do
          expect(default_site).to be_mode 644
        end
      end
    end
  end

  describe "chef-nginx::service" do
    describe "nginx service" do
      it "is enabled for startup" do
        expect(service "nginx").to be_enabled
      end

      it "is running" do
        expect(service "nginx").to be_running
      end

      it "is listening on the web port" do
        expect(port 80).to be_listening
      end
    end
  end
end
