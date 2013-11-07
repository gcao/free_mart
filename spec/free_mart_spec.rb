require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FreeMart" do
  before do
    FreeMart.clear
  end

  it "should raise error if not found" do
    lambda { FreeMart.request('key') }.should raise_error
  end

  it "should work" do
    FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'
  end

  it "clear should work" do
    FreeMart.register 'key', 'value'
    FreeMart.clear
    lambda { FreeMart.request('key') }.should raise_error
  end

  it "block should work" do
    FreeMart.register('key'){ 'value' }
    FreeMart.request('key').should == 'value'
  end

  it "block with arguments should work" do
    FreeMart.register('key') do |arg1, arg2|
      "#{arg1} value #{arg2}"
    end
    FreeMart.request('key', 'before', 'after').should == 'before value after'
  end
end
