require "spec_helper"

describe "nginx::configuration" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe, "nginx::service")
  end

  it "creates the configuration directory" do
    expect(chef_run).to create_directory("/etc/nginx").with(
      owner: "root",
      group: "root",
      recursive: true
    )
  end

  it "creates the `mime.types` file" do
    expect(chef_run).to create_cookbook_file("/etc/nginx/mime.types").with(
      source: "mime.types",
      owner: "root",
      group: "root",
      mode:  "0644"
    )

    file = chef_run.cookbook_file("/etc/nginx/mime.types")
    expect(file).to notify("service[nginx]").to(:restart)
  end

  it "creates the log directory" do
    expect(chef_run).to create_directory("/var/log/nginx").with(
      owner: "root",
      group: "root",
      recursive: true
    )
  end

  it "creates the `nginx.conf` template" do
    expect(chef_run).to create_template("/etc/nginx/nginx.conf").with(
      source: "nginx.conf.erb",
      owner: "root",
      group: "root",
      mode:  "0644"
    )

    file = chef_run.template("/etc/nginx/nginx.conf")
    expect(file).to notify("service[nginx]").to(:restart)
  end

  %w[sites-available sites-enabled].each do |vhost_dir|
    it "creates the `#{vhost_dir}` directory" do
      expect(chef_run).to create_directory("/etc/nginx/#{vhost_dir}").with(
        owner: "root",
        group: "root",
        mode: "0755"
      )
    end
  end

  context "default site" do
    let(:default_site) do
      "default"
    end

    context "when `skip_default_site` is false" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.automatic_attrs["hostname"] = "chefspechostname"
        end.converge(described_recipe, "nginx::service")
      end

      it "creates the `default` template" do
        expect(chef_run).to create_nginx_site(default_site).with(
          host: "chefspechostname",
          root: "/var/www/nginx-default"
        )
      end
    end

    context "when `skip_default_site` is true" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set["nginx"]["skip_default_site"] = true
        end.converge(described_recipe, "nginx::service")
      end

      it "does not create the `default` template" do
        expect(chef_run).to_not create_template(default_site)
      end
    end
  end

  context "conf.d entries" do
    let(:custom_entries) do
      %w[foo bar baz]
    end

    let(:default_entries) do
      %w[buffers general gzip logs performance proxy ssl_session timeouts]
    end

    context "cookbook defaults" do
      it "creates the default templates" do
        default_entries.each do |entry|
          conf_file = "/etc/nginx/conf.d/#{entry}.conf"

          expect(chef_run).to create_template(conf_file).with(
            source: "#{entry}.conf.erb",
            owner: "root",
            group: "root",
            mode:  "0644"
          )

          tmpl = chef_run.template(conf_file)
          expect(tmpl).to notify("service[nginx]").to(:restart)
        end
      end
    end

    context "custom attributes" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set["nginx"]["conf_files"] = %w[foo bar baz]
        end.converge(described_recipe, "nginx::service")
      end

      it "creates the custom templates" do
        custom_entries.each do |entry|
          conf_file = "/etc/nginx/conf.d/#{entry}.conf"

          expect(chef_run).to create_template(conf_file).with(
            source: "#{entry}.conf.erb",
            owner: "root",
            group: "root",
            mode:  "0644"
          )

          tmpl = chef_run.template(conf_file)
          expect(tmpl).to notify("service[nginx]").to(:restart)
        end
      end

      it "does not create the default templates" do
        default_entries.each do |entry|
          conf_file = "/etc/nginx/conf.d/#{entry}.conf"

          expect(chef_run).to_not create_template(conf_file)
        end
      end
    end
  end

  context "nginx status" do
    let(:status_conf) do
      "/etc/nginx/conf.d/nginx_status.conf"
    end

    context "when `enable_stub_status` is true" do
      it "creates the `nginx_status.conf` template" do
        expect(chef_run).to create_template(status_conf).with(
          source: "nginx_status.conf.erb",
          owner: "root",
          group: "root",
          mode: "0644",
          variables: { port: 80 }
        )

        tmpl = chef_run.template(status_conf)
        expect(tmpl).to notify("service[nginx]").to(:restart)
      end
    end

    context "when `enable_stub_status` is false" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set["nginx"]["enable_stub_status"] = false
        end.converge(described_recipe, "nginx::service")
      end

      it "does not create the `nginx_status.conf` template" do
        expect(chef_run).to_not create_template(status_conf)
      end
    end
  end
end
