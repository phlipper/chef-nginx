require "spec_helper"

describe "nginx::enabledisablesite" do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it "creates the `nxensite` script" do
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with("/usr/sbin/nxensite").and_return(false)

    expect(chef_run).to create_template("/usr/sbin/nxensite").with(
      source: "nxensite.erb",
      owner: "root",
      group: "root",
      mode:  "0755"
    )
  end

  it "creates the `nxdissite` link" do
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with("/usr/sbin/nxensite").and_return(true)
    allow(File).to receive(:symlink?).with("/usr/sbin/nxdissite")
      .and_return(false)

    expect(chef_run).to create_link("/usr/sbin/nxdissite").with(
      to: "/usr/sbin/nxensite"
    )
  end

  it "creates bash completion `nxendissite`" do
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with("/etc/bash_completion.d/nxendissite")
      .and_return(false)

    expect(chef_run).to create_template("/etc/bash_completion.d/nxendissite")
    .with(
      source: "nxendissite_completion.erb",
      owner: "root",
      group: "root",
      mode:  "0644"
    )
  end
end
