require 'spec_helper'

describe Spektrum::Log::Reader do

  context 'data file 1.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('1.TLM')) }

    it { should have(1466).records }

    its(:duration) { should eql(26570) }

  end

  context 'data file 2.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('2.TLM')) }

    it { should have(321106).records }

    its(:duration) { should eql(277097) }

  end

  context 'data file 3.TLM' do

    subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')) }

    it { should have(23155).records }

    its(:duration) { should eql(148365) }

  end

end