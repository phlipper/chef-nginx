require "spec_helper"

describe "nginx::debug" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it { expect(chef_run).to include_recipe("nginx::default") }

  it { expect(chef_run).to install_package("nginx-debug") }

  it { expect(chef_run).to include_recipe("nginx::configuration") }
  it { expect(chef_run).to include_recipe("nginx::service") }
end
