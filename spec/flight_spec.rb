require 'spec_helper'

describe Spektrum::Log::Flight do

  context 'data file 1.TLM' do

    context 'flight 1' do

      subject { Spektrum::Log::Reader.new(tlm_file('1.TLM')).flights[0] }

      it { should have(191).records }

      its(:duration) { should eql(1148) }

    end

    context 'flight 2' do

      subject { Spektrum::Log::Reader.new(tlm_file('1.TLM')).flights[1] }

      it { should have(634).records }

      its(:duration) { should eql(3798) }

    end

    context 'flight 3' do

      subject { Spektrum::Log::Reader.new(tlm_file('1.TLM')).flights[2] }

      it { should have(641).records }

      its(:duration) { should eql(3842) }

    end

  end

  context 'data file 2.TLM' do

    context 'flight 1' do

      subject { Spektrum::Log::Reader.new(tlm_file('2.TLM')).flights[0] }

      it { should have(260).records }

      its(:duration) { should eql(570) }

    end

  end

  context 'data file 3.TLM' do

    context 'flight 1' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[0] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 2' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[1] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 3' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[2] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 4' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[3] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 5' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[4] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 6' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[5] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 7' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[6] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 8' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[7] }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 9' do

      subject { Spektrum::Log::Reader.new(tlm_file('3.TLM')).flights[8] }

      it { should have(23155).records }

      its(:duration) { should eql(148365) }

      it { should_not be_empty }

    end

  end

  context 'data file 4.TLM' do

    context 'flight 1' do

      subject { Spektrum::Log::Reader.new(tlm_file('4.TLM')).flights[0] }

      it { should have(5440).records }

      its(:duration) { should eql(16325) }

      it { should_not be_empty }

    end

  end

end