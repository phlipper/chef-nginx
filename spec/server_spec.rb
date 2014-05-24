require "spec_helper"

describe "nginx::server" do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it { expect(chef_run).to include_recipe("nginx::default") }

  it { expect(chef_run).to install_package("nginx") }

  it { expect(chef_run).to include_recipe("nginx::configuration") }
  it { expect(chef_run).to include_recipe("nginx::service") }

  context "with a specific `package_name` and `version`" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set["nginx"]["package_name"] = "nginx-chefspec"
        node.set["nginx"]["version"] = "1.2.3"
      end.converge(described_recipe)
    end

    it "installs the specified package and version" do
      expect(chef_run).to install_package("nginx-chefspec").with_version("1.2.3")
    end
  end
end
