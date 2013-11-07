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

  it "#clear should work" do
    FreeMart.register 'key', 'value'
    FreeMart.clear
    lambda { FreeMart.request('key') }.should raise_error
  end

  it "#clear can take list of keys" do
    FreeMart.register 'a', 'aa'
    FreeMart.register 'b', 'bb'
    FreeMart.register 'c', 'cc'
    FreeMart.clear 'a', 'b'
    lambda { FreeMart.request('a') }.should raise_error
    lambda { FreeMart.request('b') }.should raise_error
    FreeMart.request('c').should == 'cc'
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

  it "#requestAll should work" do
    pending
    FreeMart.register 'key', 'a'
    FreeMart.register 'key', 'b'
    FreeMart.requestAll('key').should == ['a', 'b']
  end

  it "#requestAll should merge hash" do
    pending
    FreeMart.register 'key', a: 'aa'
    FreeMart.register 'key', b: 'bb'
    FreeMart.requestAll('key').should == {a: 'aa', b: 'bb'}
  end

  it "key arg can be anything but is converted to string" do
    pending
    FreeMart.register :a, 'aa'
    FreeMart.request(:a).should == 'aa'
    FreeMart.request('a').should == 'aa'
    FreeMart.register 2, 22
    FreeMart.request('2').should == 22
    FreeMart.request(:'2').should == 22
  end
end
