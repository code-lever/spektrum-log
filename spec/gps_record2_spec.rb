require 'spec_helper'

describe Spektrum::Log::GPSRecord2 do

  let(:timestamp) { 0x0002C8D5 }

  let(:raw_data) { ["00500000184412110018099909073B"].pack('H*') }

  subject { Spektrum::Log::GPSRecord2.new(timestamp, raw_data) }

  its(:timestamp) { should eql(0x0002C8D5) }

  its(:satellites) { should eql(11) }

  its(:time) { should eq('12:44:18.00') }

end
