require 'spec_helper'

describe Spektrum::Log::File do

  describe '#new' do

    context 'with data file 1.TLM' do

      subject { Spektrum::Log::File.new(data_file('1.TLM')) }

      it { should have(3).flights }

      its(:duration) { should be_within(0.1).of(34.3) }

    end

    context 'with data file 2.TLM' do

      subject { Spektrum::Log::File.new(data_file('2.TLM')) }

      it { should have(312).flights }

      its(:duration) { should be_within(0.1).of(3433.1) }

    end

    context 'with data file 3.TLM' do

      subject { Spektrum::Log::File.new(data_file('3.TLM')) }

      it { should have(12).flights }

      its(:duration) { should be_within(0.1).of(579.5) }

    end

    context 'with data file 4.TLM' do

      subject { Spektrum::Log::File.new(data_file('4.TLM')) }

      it { should have(1).flights }

      its(:duration) { should be_within(0.1).of(63.8) }

    end

    context 'with data file GPS.TLM' do

      subject { Spektrum::Log::File.new(data_file('GPS.TLM')) }

      it { should have(2).flights }

      its(:duration) { should be_within(0.1).of(1431.4) }

    end

    context 'with data file GPS2.TLM' do

      subject { Spektrum::Log::File.new(data_file('GPS2.TLM')) }

      it { should have(2).flights }

      its(:duration) { should be_within(0.1).of(851.0) }

    end

    context 'with data file X5-G700.TLM' do

      subject { Spektrum::Log::File.new(data_file('X5-G700.TLM')) }

      it { should have(3).flights }

      its(:duration) { should be_within(0.1).of(972.9) }

    end

    context 'with data file X5-GPS1.TLM' do

      subject { Spektrum::Log::File.new(data_file('X5-GPS1.TLM')) }

      it { should have(5).flights }

      its(:duration) { should be_within(0.1).of(1305.2) }

    end

    context 'with data file X5-GPS2.TLM' do

      subject { Spektrum::Log::File.new(data_file('X5-GPS2.TLM')) }

      it { should have(2).flights }

      its(:duration) { should be_within(0.1).of(627.7) }

    end

    it 'should raise for invalid or missing files' do
      files = invalid_data_files
      files.should have(17).files

      files.each do |f|
        expect { Spektrum::Log::File.new(f) }.to raise_error
      end
    end

  end

  describe '#spektrum?' do

    it 'should be false for invalid or missing files' do
      files = invalid_data_files
      files.should have(17).files

      files.each do |f|
        Spektrum::Log::File.spektrum?(f).should be_false
      end
    end

    it 'should be true for valid files' do
      files = data_files
      files.should have(10).files

      files.each do |f|
        Spektrum::Log::File.spektrum?(f).should be_true
      end
    end

  end

  describe '#to_kml_file' do

    context 'with file with GPS data' do

      subject { Spektrum::Log::File.new(data_file('X5-G700.TLM')) }

      its(:to_kml?) { should be_true }

      its(:to_kml) { should be_a(String) }

    end

    context 'with file without GPS data' do

      subject { Spektrum::Log::File.new(data_file('3.TLM')) }

      its(:to_kml?) { should be_false }

      it 'should raise w/o kml data' do
        expect { subject.to_kml }.to raise_error
      end

    end

  end

end
