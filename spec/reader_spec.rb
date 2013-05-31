require 'spec_helper'

describe Spektrum::Log::Reader do

  context 'data file 1.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('1.TLM')) }

    it { should have(3).flights }

  end

  context 'data file 2.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('2.TLM')) }

    it { should have(312).flights }

  end

  context 'data file 3.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('3.TLM')) }

    it { should have(12).flights }

  end

  context 'data file 4.TLM' do

    subject { Spektrum::Log::Reader.new(data_file('4.TLM')) }

    it { should have(1).flights }

  end

  it 'should raise on bad input' do
    expect { Spektrum::Log::Reader.new(__FILE__) }.to raise_error
  end

end
