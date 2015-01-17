require "spec_helper"

describe "nginx::server" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  specify do
    expect(chef_run).to include_recipe("nginx::default")

    expect(chef_run).to install_package("nginx")
    expect(chef_run).to_not install_package("nginx-common")

    expect(chef_run).to include_recipe("nginx::configuration")
    expect(chef_run).to include_recipe("nginx::service")
    expect(chef_run).to include_recipe("nginx::enabledisablesite")
  end

  context "with a specific `package_name` and `version`" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["nginx"]["package_name"] = "nginx-chefspec"
        node.set["nginx"]["version"] = "1.2.3"
      end.converge(described_recipe)
    end

    it "installs the specified package and version" do
      expect(chef_run).to(
        install_package("nginx-chefspec").with_version("1.2.3")
      )
    end
  end

  context "with `ppa` or `phusion` repository sources" do
    context "ppa" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set["nginx"]["repository"] = "ppa"
        end.converge(described_recipe)
      end

      specify do
        expect(chef_run).to install_package "nginx-common"
      end
    end

    context "phusion" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.set["nginx"]["repository"] = "phusion"
        end.converge(described_recipe)
      end

      specify do
        expect(chef_run).to install_package "nginx-common"
      end
    end
  end
end
