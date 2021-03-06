require 'spec_helper'

describe Spektrum::Log::Flight do

  context 'with data file 1.TLM' do

    before(:all) { @file = _1_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      it { should have(4).headers }

      it { should have(191).records }

      its(:duration) { should be_within(0.1).of(4.5) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Stinson') }

      its(:model_number) { should eql(1) }

      its(:model_type) { should eql('Fixed Wing') }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(false) }

      its(:gps2_records?) { should be(true) }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      it { should have(4).headers }

      it { should have(634).records }

      its(:duration) { should be_within(0.1).of(14.8) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(true) }

      its(:gps2_records?) { should be(true) }

    end

    context 'flight 3' do

      subject { @file.flights[2] }

      it { should have(4).headers }

      it { should have(641).records }

      its(:duration) { should be_within(0.1).of(15.0) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(true) }

      its(:gps2_records?) { should be(true) }

    end

  end

  context 'with data file 2.TLM' do

    before(:all) { @file = _2_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      it { should have(5).headers }

      it { should have(260).records }

      it { should_not be_empty }

      its(:duration) { should be_within(0.1).of(2.2) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Voodoo 600 SK540') }

      its(:model_number) { should eql(1) }

      its(:model_type) { should eql('Helicopter') }

      its(:telemetry_unit) { should == 'TM1100' }

      its(:to_kml?) { should be(false) }

    end

    context 'flight 305' do

      subject { @file.flights[304] }

      its(:model_name) { should eql('ERW|N XL ULTRALIGHT') }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 306' do

      subject { @file.flights[305] }

      its(:model_name) { should eql('ERW|N XL ULTRALIGHT') }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 308' do

      subject { @file.flights[307] }

      its(:model_name) { should eql('ERW|N XL ULTRALIGHT') }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 312' do

      subject { @file.flights[311] }

      its(:model_name) { should eql('ERW|N XL ULTRALIGHT') }

      its(:to_kml?) { should be(true) }

    end

  end

  context 'with data file 3.TLM' do

    before(:all) { @file = _3_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 3' do

      subject { @file.flights[2] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 4' do

      subject { @file.flights[3] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 5' do

      subject { @file.flights[4] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 6' do

      subject { @file.flights[5] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 7' do

      subject { @file.flights[6] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 8' do

      subject { @file.flights[7] }

      it { should have(5).headers }

      it { should have(0).records }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

      it { should be_empty }

    end

    context 'flight 9' do

      subject { @file.flights[8] }

      it { should have(5).headers }

      it { should have(23155).records }

      its(:duration) { should be_within(0.1).of(579.5) }

      its(:telemetry_unit) { should == 'TM1100' }

      it { should_not be_empty }

    end

  end

  context 'with data file 4.TLM' do

    before(:all) { @file = _4_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      it { should have(5).headers }

      it { should have(5440).records }

      it { should_not be_empty }

      its(:duration) { should be_within(0.1).of(63.8) }

      its(:bind_type) { should eql('DSMX') }

      its(:model_name) { should eql('Goblin 700') }

      its(:model_number) { should eql(5) }

      its(:model_type) { should eql('Helicopter') }

      its(:telemetry_unit) { should == 'TM1100' }

      its(:altimeter_records?) { should be(false) }

      its(:basic_data_records?) { should be(true) }

      its(:flight_log_records?) { should be(true) }

      its(:g_force_records?) { should be(false) }

      its(:gps1_records?) { should be(false) }

      its(:gps2_records?) { should be(false) }

      its(:speed_records?) { should be(false) }

    end

  end

  context 'with data file GPS.TLM' do

    before(:all) { @file = gps_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      its(:duration) { should be_within(1).of(697) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(true) }

      it { should have(6419).gps1_records }

      its(:gps2_records?) { should be(true) }

      it { should have(7096).gps2_records }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      its(:duration) { should be_within(1).of(733) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(true) }

      it { should have(7718).gps1_records }

      its(:gps2_records?) { should be(true) }

      it { should have(7710).gps2_records }

      its(:to_kml?) { should be(true) }

    end

  end

  context 'with data file GPS2.TLM' do

    before(:all) { @file = gps2_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      its(:duration) { should be_within(1).of(503) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:gps1_records?) { should be(true) }

      it { should have(10647).gps1_records }

      its(:gps2_records?) { should be(true) }

      it { should have(10645).gps2_records }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      its(:duration) { should be_within(1).of(347) }

      its(:telemetry_unit) { should == 'TM1000' }

      it { should have(4792).gps1_records }

      its(:gps2_records?) { should be(true) }

      it { should have(4795).gps2_records }

      its(:to_kml?) { should be(true) }

    end

  end

  context 'with data file X5-G700.TLM' do

    before(:all) { @file = x5_g700_tlm }

    subject { @file }

    context 'flight 1' do

      subject { @file.flights[0] }

      its(:duration) { should be_within(0.1).of(323.6) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      its(:duration) { should be_within(0.1).of(323.8) }

      its(:telemetry_unit) { should == 'TM1100' }

    end

    context 'flight 3' do

      subject { @file.flights[2] }

      its(:duration) { should be_within(0.1).of(325.5) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

  end

  context 'with data file X5-GPS1.TLM' do

    before(:all) { @file = x5_gps1_tlm }

    subject { @file }

    its 'flights should contain some gps coordinates' do

      @file.flights.select { |f| f.gps1_records? }.should have(4).flights

    end

    its 'longitudes should all be negative' do

      @file.flights.each do |flight|

        flight.gps1_records.each do |gps1|
          gps1.longitude.should be < 0.0
        end

      end

    end

    context 'flight 1' do

      subject { @file.flights[0] }

      its(:duration) { should be_within(0.1).of(318.6) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      its(:duration) { should be_within(0.1).of(327.5) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

    context 'flight 3' do

      subject { @file.flights[2] }

      its(:duration) { should be_within(0.1).of(326.5) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

    context 'flight 4' do

      subject { @file.flights[3] }

      its(:duration) { should eql(0.0) }

      its(:telemetry_unit) { should == 'None' }

    end

    context 'flight 5' do

      subject { @file.flights[4] }

      its(:duration) { should be_within(0.1).of(332.6) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

  end

  context 'with data file X5-GPS2.TLM' do

    before(:all) { @file = x5_gps2_tlm }

    subject { @file }

    its 'flights should contain some gps coordinates' do

      @file.flights.select { |f| f.gps1_records? }.should have(2).flights

    end

    its 'longitudes should all be negative' do

      @file.flights.each do |flight|

        flight.gps1_records.each do |gps1|
          gps1.longitude.should be < 0.0
        end

      end

    end

    context 'flight 1' do

      subject { @file.flights[0] }

      its(:duration) { should be_within(0.1).of(328.6) }

      its(:telemetry_unit) { should == 'TM1000' }

      its(:to_kml?) { should be(true) }

    end

    context 'flight 2' do

      subject { @file.flights[1] }

      its(:duration) { should be_within(0.1).of(299.1) }

      its(:telemetry_unit) { should == 'TM1000' }

    end

  end

  describe '#to_kml' do

    let(:file) { Spektrum::Log::File.new(data_file('X5-G700.TLM')) }

    context 'with flight 1' do

      subject { file.flights[0] }

      its(:to_kml) { should be_a(String) }

    end

    context 'with flight 2' do

      subject { file.flights[1] }

      it 'should raise w/o kml data' do
        expect { subject.to_kml }.to raise_error(RuntimeError)
      end

    end

    context 'with flight 3' do

      subject { file.flights[2] }

      its(:to_kml) { should be_a(String) }

    end

  end

  describe '#to_kml_file' do

    let(:file) { Spektrum::Log::File.new(data_file('X5-G700.TLM')) }

    context 'with flight 1' do

      subject { file.flights[0] }

      its(:to_kml_file) { should be_a(KMLFile) }

      it 'should take options for file and placemark' do
        kml = subject.to_kml_file({ :name => 'File Name' }, { :name => 'Placemark Name' })
        kml.objects[0].name.should eql('File Name')
        kml.objects[0].features[0].name.should eql('Placemark Name')
      end

    end

    context 'with flight 2' do

      subject { file.flights[1] }

      it 'should raise w/o kml data' do
        expect { subject.to_kml_file }.to raise_error(RuntimeError)
      end

    end

    context 'with flight 3' do

      subject { file.flights[2] }

      its(:to_kml_file) { should be_a(KMLFile) }

    end

  end

  describe '#to_kml_placemark' do

    let(:file) { Spektrum::Log::File.new(data_file('X5-G700.TLM')) }

    context 'with flight 1' do

      subject { file.flights[0] }

      its(:to_kml_placemark) { should be_a(KML::Placemark) }

    end

    context 'with flight 2' do

      subject { file.flights[1] }

      it 'should raise w/o kml data' do
        expect { subject.to_kml_placemark }.to raise_error(RuntimeError)
      end

    end

    context 'with flight 3' do

      subject { file.flights[2] }

      its(:to_kml_placemark) { should be_a(KML::Placemark) }

    end

  end

end
