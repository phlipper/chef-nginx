require "spec_helper"

describe "nginx::default" do
  let(:apt_source) do
    "/etc/apt/sources.list.d/nginx.list"
  end

  context "official source" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it "sets up the 'official' repository" do
      expect(chef_run).to add_apt_repository("nginx")

      # expect(chef_run).to(
      #   render_file(apt_source).with_content(
      #     %r(http://nginx.org/packages)
      #   )
      # )
    end
  end

  context "ppa source" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["nginx"]["repository"] = "ppa"
      end.converge(described_recipe)
    end

    it "sets up the 'ppa' repository" do
      expect(chef_run).to add_apt_repository("nginx")

      # expect(chef_run).to(
      #   render_file(apt_source).with_content(
      #     %r(http://ppa.launchpad.net/nginx/stable/ubuntu)
      #   )
      # )
    end
  end

  context "phusion source" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["nginx"]["repository"] = "phusion"
      end.converge(described_recipe)
    end

    it "sets up the 'phusion' repository" do
      expect(chef_run).to add_apt_repository("nginx")

      # expect(chef_run).to(
      #   render_file(apt_source).with_content(
      #     %r(https://oss-binaries.phusionpassenger.com/apt/passenger)
      #   )
      # )
    end
  end

  context "invalid source" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["nginx"]["repository"] = "invalid"
      end.converge(described_recipe)
    end

    it "raises an exception" do
      expect(-> { chef_run }).to raise_error(KeyError)
    end
  end
end
