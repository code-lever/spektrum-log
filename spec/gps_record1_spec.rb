require 'spec_helper'

describe Spektrum::Log::GPSRecord1 do

  let(:timestamp) { 0x00010E8D }

  let(:raw_data) { ["00870084214054886918094633093B"].pack('H*') }

  subject { Spektrum::Log::GPSRecord1.new(timestamp, raw_data) }

  its(:timestamp) { should eql(0x00010E8D) }

  its(:latitude) { should be_within(0.000001).of(54.670307) }

  its(:longitude) { should be_within(0.000001).of(9.311646) }

end
