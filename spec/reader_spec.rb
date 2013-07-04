require 'spec_helper'

describe Spektrum::Log::Reader do

  context 'data file 1.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('1.TLM')) }

    it { should have(3).flights }

    its(:duration) { should be_within(0.1).of(34.3) }

  end

  context 'data file 2.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('2.TLM')) }

    it { should have(312).flights }

    its(:duration) { should be_within(0.1).of(1570.7) }

  end

  context 'data file 3.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('3.TLM')) }

    it { should have(12).flights }

    its(:duration) { should be_within(0.1).of(144.8) }

  end

  context 'data file 4.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('4.TLM')) }

    it { should have(1).flights }

    its(:duration) { should be_within(0.1).of(15.9) }

  end

  context 'data file GPS.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('GPS.TLM')) }

    it { should have(2).flights }

    its(:duration) { should be_within(0.1).of(1431.4) }

  end

  context 'data file GPS2.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('GPS2.TLM')) }

    it { should have(2).flights }

    its(:duration) { should be_within(0.1).of(851.0) }

  end

  context 'data file X5-GPS1.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('X5-GPS1.TLM')) }

    it { should have(5).flights }

    its(:duration) { should be_within(0.1).of(1305.2) }

  end

  context 'data file X5-GPS2.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('X5-GPS2.TLM')) }

    it { should have(2).flights }

    its(:duration) { should be_within(0.1).of(627.7) }

  end

  it 'should raise on bad input' do
    expect { Spektrum::Log::Reader.new(__FILE__) }.to raise_error
  end

  it 'should raise when file is not found' do
    expect { Spektrum::Log::Reader.new(data_file('NOFILE.TLM')) }.to raise_error
  end

end
