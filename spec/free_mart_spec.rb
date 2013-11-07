require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FreeMart" do
  before do
    FreeMart.clear
  end

  it "should work" do
    FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'
  end

  it "#register should return the value if the value is a constant" do
    provider = FreeMart.register 'key', 'value'
    provider.should == 'value'
  end

  it "should raise error if not found" do
    lambda { FreeMart.request('key') }.should raise_error
  end

  it "#deregister should work" do
    provider = FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'
    FreeMart.deregister 'key', provider
    lambda { FreeMart.request('key') }.should raise_error
  end

  it "#reregister should work" do
    FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'

    FreeMart.reregister 'key' do |proxy, *args|
      old_result = if proxy.respond_to? :call
                     proxy.call
                   else
                     proxy
                   end

      "#{old_result} #{args.join(' ')}"
    end
    FreeMart.request('key', 'a', 'b').should == 'value a b'
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

  it "#register should return a provider if a block is passed in" do
    provider = FreeMart.register('key'){ 'value' }
    provider.call.should == 'value'
  end

  it "block with arguments should work" do
    FreeMart.register('key') do |arg1, arg2|
      "#{arg1} value #{arg2}"
    end
    FreeMart.request('key', 'before', 'after').should == 'before value after'
  end

  it "should support multiple providers for same key" do
    FreeMart.register('key') do |index|
      if index == 1
        'first'
      else
        FreeMart.not_found
      end
    end
    FreeMart.register('key') do |index|
      if index == 2
        'second'
      else
        FreeMart.not_found
      end
    end
    FreeMart.request('key', 1).should == 'first'
    FreeMart.request('key', 2).should == 'second'
    lambda { FreeMart.request('key', 3) }.should raise_error
  end
end
