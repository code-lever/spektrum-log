require 'spec_helper'

describe Spektrum::Log::Flight do

  context 'data file 1.TLM' do

    let(:reader) { Spektrum::Log::Reader.new(data_file('1.TLM')) }

    context 'flight 1' do

      subject { reader.flights[0] }

      it { should have(4).headers }

      it { should have(191).records }

      its(:duration) { should eql(4) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Stinson') }

      its(:model_number) { should eql(1) }

      its(:model_type) { should eql('Fixed Wing') }

    end

    context 'flight 2' do

      subject { reader.flights[1] }

      it { should have(4).headers }

      it { should have(634).records }

      its(:duration) { should eql(14) }

    end

    context 'flight 3' do

      subject { reader.flights[2] }

      it { should have(4).headers }

      it { should have(641).records }

      its(:duration) { should eql(15) }

    end

  end

  context 'data file 2.TLM' do

    let(:reader) { Spektrum::Log::Reader.new(data_file('2.TLM')) }

    context 'flight 1' do

      subject { reader.flights[0] }

      it { should have(5).headers }

      it { should have(260).records }

      it { should_not be_empty }

      its(:duration) { should eql(2) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Voodoo 600') }

      its(:model_number) { should eql(1) }

      its(:model_type) { should eql('Helicopter') }

    end

  end

  context 'data file 3.TLM' do

    let(:reader) { Spektrum::Log::Reader.new(data_file('3.TLM')) }

    context 'flight 1' do

      subject { reader.flights[0] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 2' do

      subject { reader.flights[1] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 3' do

      subject { reader.flights[2] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 4' do

      subject { reader.flights[3] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 5' do

      subject { reader.flights[4] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 6' do

      subject { reader.flights[5] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 7' do

      subject { reader.flights[6] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 8' do

      subject { reader.flights[7] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0) }

      it { should be_empty }

    end

    context 'flight 9' do

      subject { reader.flights[8] }

      it { should have(5).headers }

      it { should have(23155).records }

      its(:duration) { should eql(579) }

      it { should_not be_empty }

    end

  end

  context 'data file 4.TLM' do

    let(:reader) { Spektrum::Log::Reader.new(data_file('4.TLM')) }

    context 'flight 1' do

      subject { reader.flights[0] }

      it { should have(5).headers }

      it { should have(5440).records }

      it { should_not be_empty }

      its(:duration) { should eql(63) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Goblin 700') }

      its(:model_number) { should eql(5) }

      its(:model_type) { should eql('Helicopter') }

      its(:altimeter_records?) { should be_false }

      its(:basic_data_records?) { should be_true }

      its(:flight_log_records?) { should be_true }

      its(:g_force_records?) { should be_false }

      its(:gps1_records?) { should be_false }

      its(:gps2_records?) { should be_false }

      its(:speed_records?) { should be_false }

    end

  end

end