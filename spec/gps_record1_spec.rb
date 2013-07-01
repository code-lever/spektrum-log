require 'spec_helper'

describe Spektrum::Log::GPSRecord1 do

  let(:timestamp) { 0x00010E8D }

  subject { Spektrum::Log::GPSRecord1.new(timestamp, raw_data) }

  context 'data set 1' do

    let(:raw_data) { ["00870084214054886918094633093B"].pack('H*') }

    its(:timestamp) { should eql(0x00010E8D) }

    its(:altitude) { should be_within(0.1).of(28.5) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(8.7)
    end

    its(:heading) { should be_within(0.1).of(334.6)}

    its(:latitude) { should be_within(0.000001).of(54.670307) }

    its(:longitude) { should be_within(0.000001).of(9.311646) }

  end

  context 'data set 2' do

    let(:raw_data) { ["00660221234054966218093030103B"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(87.3) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(26.6)
    end

    its(:heading) { should be_within(0.1).of(303.0)}

  end

  context 'data set 3' do

    let(:raw_data) { ["00130052242101046851036804153F"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(4.3) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(1.3)
    end

    its(:heading) { should be_within(0.1).of(46.8)}

    its(:latitude) { should be_within(0.000001).of(1.354086) }

    its(:longitude) { should be_within(0.000001).of(103.861399) }

  end

  context 'data set 4' do

    let(:raw_data) { ["00560359222101676651038623141F"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(116.8) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(35.6)
    end

    its(:heading) { should be_within(0.1).of(238.6)}

    its(:latitude) { should be_within(0.000001).of(1.353765) }

    its(:longitude) { should be_within(0.000001).of(103.861111) }

  end

  context 'data set 5' do

    let(:raw_data) { ["00142125250249434045084625183B"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(693.6) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(211.4)
    end

    its(:heading) { should be_within(0.1).of(254.6)}

    its(:latitude) { should be_within(0.000001).of(49.037542) }

    its(:longitude) { should be_within(0.000001).of(8.756738) }

  end

  context 'data set 6' do

    let(:raw_data) { ["007430561011417459009672350939"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(1008.5) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(307.4)
    end

    its(:heading) { should be_within(0.1).of(357.2)}

    its(:latitude) { should be_within(0.000001).of(41.185093) }

    its(:longitude) { should be_within(0.000001).of(-96.009956) }

  end

  context 'data set 7' do

    let(:raw_data) { ["005518231111415959009602100939"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(608.6) }

    it 'should allow altitude in meters' do
      subject.altitude(:meters).should be_within(0.1).of(185.5)
    end

    its(:heading) { should be_within(0.1).of(100.2)}

    its(:latitude) { should be_within(0.000001).of(41.185205) }

    its(:longitude) { should be_within(0.000001).of(-96.009932) }

  end

end
