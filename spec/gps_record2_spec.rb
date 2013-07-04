require 'spec_helper'

describe Spektrum::Log::GPSRecord2 do

  let(:timestamp) { 0x0002C8D5 }

  subject { Spektrum::Log::GPSRecord2.new(timestamp, raw_data) }

  context 'data set 1' do

    let(:raw_data) { ["1700500000184412110018099909073B"].pack('H*') }

    its(:timestamp) { should eql(0x0002C8D5) }

    its(:satellites) { should eql(11) }

    its(:speed) { should be_within(0.1).of(5.0) }

    it 'should allow speed in mph' do
      subject.speed(:mph).should be_within(0.1).of(5.8)
    end

    it 'should allow speed in kph' do
      subject.speed(:kph).should be_within(0.1).of(9.3)
    end

    its(:time) { should eq('12:44:18.00') }

  end

  context 'data set 2' do

    let(:raw_data) { ["1700270300011013080018093030103B"].pack('H*') }

    its(:satellites) { should eql(8) }

    its(:speed) { should be_within(0.1).of(32.7) }

    it 'should allow speed in mph' do
      subject.speed(:mph).should be_within(0.1).of(37.6)
    end

    it 'should allow speed in kph' do
      subject.speed(:kph).should be_within(0.1).of(60.6)
    end

    its(:time) { should eq('13:10:01.00') }

  end

end
