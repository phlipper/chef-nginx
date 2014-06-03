require "spec_helper"

describe "nginx::enabledisablesite" do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it "creates the `nxensite` script" do
    ::File.stub(:exists?).with(anything).and_call_original
    ::File.stub(:exists?).with("/usr/sbin/nxensite").and_return(false)

    expect(chef_run).to create_template("/usr/sbin/nxensite").with(
      source: "nxensite.erb",
      owner: "root",
      group: "root",
      mode:  "0755"
    )
  end

  it "creates the `nxdissite` link" do
    ::File.stub(:exists?).with(anything).and_call_original
    ::File.stub(:exists?).with("/usr/sbin/nxensite").and_return(true)
    ::File.stub(:symlink?).with("/usr/sbin/nxdissite").and_return(false)

    expect(chef_run).to run_execute("ln -s /usr/sbin/nxensite /usr/sbin/nxdissite")
  end

  it "creates bash completion `nxendissite`" do
    ::File.stub(:exists?).with(anything).and_call_original
    ::File.stub(:exists?).with("/etc/bash_completion.d/nxendissite").and_return(false)

    expect(chef_run).to create_template("/etc/bash_completion.d/nxendissite").with(
      source: "nxendissite_completion.erb",
      owner: "root",
      group: "root",
      mode:  "0644"
    )
  end
end
