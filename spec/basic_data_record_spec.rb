require 'spec_helper'

describe Spektrum::Log::BasicDataRecord do

  let(:timestamp) { 0xC67C0100 }

  let(:raw_data) { ["7E00FFFF13897FFF0000000000000000"].pack('H*') }

  subject { Spektrum::Log::BasicDataRecord.new(timestamp, raw_data) }

  its(:timestamp) { should eql(0xC67C0100) }

  context 'with only rpm' do

    let(:raw_data) { ["FE000123FFFF7FFF0000000000000000"].pack('H*') }

    its(:rpm?) { should be(true) }

    it 'calculates RPMs appropriately' do
      subject.rpm(6).should eq(1746)
    end

    its(:temperature?) { should be(false) }

    its(:voltage?) { should be(false) }

  end

  context 'with only temperature' do

    let(:raw_data) { ["7E00FFFFFFFF00A10000000000000000"].pack('H*') }

    its(:rpm?) { should be(false) }

    its(:temperature?) { should be(true) }

    its(:temperature) { should eq(161) }

    it 'should allow temperature in celsius' do
      subject.temperature(:c).should be_within(0.1).of(71.7)
    end

    its(:voltage?) { should be(false) }

  end

  context 'with only voltage' do

    let(:raw_data) { ["FE00FFFF13897FFF0000000000000000"].pack('H*') }

    its(:rpm?) { should be(false) }

    its(:temperature?) { should be(false) }

    its(:voltage?) { should be(true) }

    its(:voltage) { should eq(50.01) }

  end

  context 'with everything' do

    let(:raw_data) { ["7E0000A6138900A60000000000000000"].pack('H*') }

    its(:rpm?) { should be(true) }

    it 'calculates RPMs appropriately' do
      subject.rpm(12).should eq(1992)
    end

    its(:temperature?) { should be(true) }

    its(:temperature) { should eq(166) }

    its(:voltage?) { should be(true) }

    its(:voltage) { should eq(50.01) }

  end

end
