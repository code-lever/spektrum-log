require 'spec_helper'

describe "My behaviour" do

  it 'should do something' do

    #To change this template use File | Settings | File Templates.
    true.should == false
  end

  it 'derps' do
    reader = Spektrum::Log::Reader.new(tlm_file('1.TLM'))
    puts reader.records.length
    puts reader.duration
  end

  it 'herps' do
    reader = Spektrum::Log::Reader.new(tlm_file('2.TLM'))
    puts reader.records.length
    puts reader.duration
  end

  it 'berps' do
    reader = Spektrum::Log::Reader.new(tlm_file('3.TLM'))
    puts reader.records.length
    puts reader.duration
  end

end