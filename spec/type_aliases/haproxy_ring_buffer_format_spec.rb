require 'spec_helper'

describe 'Haproxy::Ring_buffer_format' do
  # Valid enum declarations
  it { is_expected.to allow_value('iso') }
  it { is_expected.to allow_value('raw') }
  it { is_expected.to allow_value('rfc3164') }
  it { is_expected.to allow_value('rfc5424') }
  it { is_expected.to allow_value('short') }
  it { is_expected.to allow_value('timed') }

  # Disallowed
  it { is_expected.not_to allow_value('') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value(3399) }
  it { is_expected.not_to allow_value('monotonic') }
end
