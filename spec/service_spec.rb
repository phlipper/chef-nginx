require 'spec_helper'

describe 'nginx::server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it { expect(chef_run).to enable_service('nginx') }
  it { expect(chef_run).to start_service('nginx') }
end
