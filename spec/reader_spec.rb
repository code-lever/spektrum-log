require 'spec_helper'

describe Spektrum::Log::Reader do

  context 'data file 1.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('1.TLM')) }

    it { should have(3).flights }

  end

  context 'data file 2.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('2.TLM')) }

    it { should have(312).flights }

  end

  context 'data file 3.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')) }

    it { should have(12).flights }

  end

  context 'data file 4.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('4.TLM')) }

    it { should have(1).flights }

  end

end
