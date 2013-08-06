require 'spec_helper'

describe Spektrum::Log::SpeedRecord do

  let(:timestamp) { 0xC67C0FE2 }

  let(:raw_data) { ["1100010501F900000000000000000000"].pack('H*') }

  subject { Spektrum::Log::SpeedRecord.new(timestamp, raw_data) }

  its(:timestamp) { should eql(0xC67C0FE2) }

  it 'should have a speed in mph' do
    subject.speed(:mph).should be_within(0.1).of(162.2)
  end

  it 'should have a speed in kph' do
    subject.speed(:kph).should be_within(0.1).of(261)
  end

  its(:speed) { should be_within(0.1).of(140.9) }

  it 'should have a speed in knots' do
    subject.speed(:knots).should be_within(0.1).of(140.9)
  end

end
