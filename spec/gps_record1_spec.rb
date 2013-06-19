require 'spec_helper'

describe Spektrum::Log::GPSRecord1 do

  let(:timestamp) { 0x00010E8D }

  subject { Spektrum::Log::GPSRecord1.new(timestamp, raw_data) }

  context 'data set 1' do

    let(:raw_data) { ["00870084214054886918094633093B"].pack('H*') }

    its(:timestamp) { should eql(0x00010E8D) }

    its(:altitude) { should be_within(0.1).of(28.5) }

    its(:heading) { should be_within(0.01).of(334.6)}

    its(:latitude) { should be_within(0.000001).of(54.670307) }

    its(:longitude) { should be_within(0.000001).of(9.311646) }

  end

  context 'data set 2' do

    let(:raw_data) { ["00660221234054966218093030103B"].pack('H*') }

    its(:altitude) { should be_within(0.1).of(87.3) }

    its(:heading) { should be_within(0.01).of(303.0)}

  end

end
