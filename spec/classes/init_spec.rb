require 'spec_helper'
describe 'ovirt' do

  context 'with defaults for all parameters' do
    it { should contain_class('ovirt') }
  end
end
