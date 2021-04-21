# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact do # rubocop:disable RSpec/FilePath
  before(:each) do
    Facter.clear
  end

  context 'when haproxy is present' do
    haproxy_version_output = <<-PUPPETCODE
      HA-Proxy version 1.5.3 2014/07/25
      Copyright 2000-2014 Willy Tarreau <w@1wt.eu>
    PUPPETCODE
    it do
      expect(Facter::Util::Resolution).to receive(:which).at_least(1).with('haproxy').and_return(true)
      expect(Facter::Util::Resolution).to receive(:exec).at_least(1).with('haproxy -v 2>&1').and_return(haproxy_version_output)
      expect(Facter.fact(:haproxy_version).value).to eq '1.5.3'
    end
  end

  context 'when haproxy is not present' do
    it do
      allow(Facter::Util::Resolution).to receive(:exec)
      expect(Facter::Util::Resolution).to receive(:which).at_least(1).with('haproxy').and_return(false)
      expect(Facter.fact(:haproxy_version).value).to be_nil
    end
  end
end
