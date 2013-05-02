require 'spec_helper'

describe Spektrum::Log::FlightLogRecord do

  let(:timestamp) { 0xC67C0101 }

  let(:raw_data) { ["00FFFF13897FFF0000000000000347"].pack('H*') }

  subject { Spektrum::Log::FlightLogRecord.new(timestamp, raw_data) }

  its(:timestamp) { should eql(0xC67C0101) }

  context 'with voltage' do

    let(:raw_data) { ["00FFFF13897FFF0000000000000347"].pack('H*') }

    its(:rx_voltage?) { should be_true }

    its(:rx_voltage) { should eq(8.39) }

  end

  context 'without voltage' do

    let(:raw_data) { ["00FFFF13897FFF0000000000007FFF"].pack('H*') }

    its(:rx_voltage?) { should be_false }

  end

end
