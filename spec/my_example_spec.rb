require 'spec_helper'

describe "My behaviour" do

  it 'derps' do
    reader = Spektrum::Log::Reader.new(tlm_file('1.TLM'))
    puts reader.record_count
    puts reader.duration
  end

  it 'herps' do
    reader = Spektrum::Log::Reader.new(tlm_file('2.TLM'))
    puts reader.record_count
    puts reader.duration
  end

  it 'berps' do
    reader = Spektrum::Log::Reader.new(tlm_file('3.TLM'))
    puts reader.record_count
    puts reader.duration
  end

end