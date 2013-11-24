require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FreeMart do
  before do
    FreeMart.clear
  end

  it "should work" do
    FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'
  end

  it "block should work" do
    FreeMart.register('key'){ 'value' }
    FreeMart.request('key').should == 'value'
  end

  it "parameters are passed to block" do
    FreeMart.register('key'){|_, *args| args }
    FreeMart.request('key', 'a', 'b').should == ['a', 'b']
  end

  it "block with arguments should work" do
    FreeMart.register('key') do |_, arg1, arg2|
      "#{arg1} value #{arg2}"
    end
    FreeMart.request('key', 'before', 'after').should == 'before value after'
  end

  it "#register should return a provider that can be 'call'ed" do
    provider = FreeMart.register 'key', 'value'
    provider.call.should == 'value'
  end

  it "#register can take regular expression" do
    FreeMart.register /key/, 'value'
    FreeMart.request('key1').should == 'value'
  end

  it "#register can take an array of regular expressions and strings" do
    FreeMart.register [/first/, 'second'] do |options|
      options[:key]
    end
    FreeMart.request('first').should == 'first'
    FreeMart.request('second').should == 'second'
  end

  it "requested key is passed to callback" do
    FreeMart.register /key/ do |options|
      options[:key]
    end
    FreeMart.request('key1').should == 'key1'
    FreeMart.request('key2').should == 'key2'
  end

  it "provider registered later overwrite previous provider with same key" do
    FreeMart.register 'key', 'value'
    FreeMart.register 'key', 'value1'
    FreeMart.request('key').should == 'value1'
  end

  it "provider registered later can call request to get value from previous provider" do
    FreeMart.register 'key', 'value'
    FreeMart.register 'key' do |options|
      FreeMart.request options[:key]
    end
    FreeMart.request('key').should == 'value'
  end

  #it "#request should raise error if not found" do
  #  lambda { FreeMart.request('key') }.should raise_error(FreeMart::NotFoundError)
  #end

  #it "should raise no provider error if no provider exists for the key" do
  #  lambda { FreeMart.request('key') }.should raise_error(FreeMart::NoProviderError)
  #end

  #it "#request_no_error should return NOT_FOUND if not found" do
  #  FreeMart.request_no_error('key').should == FreeMart::NOT_FOUND
  #end

  #it "#deregister should work" do
  #  provider = FreeMart.register 'key', 'value'
  #  FreeMart.request('key').should == 'value'
  #  FreeMart.deregister 'key', provider
  #  lambda { FreeMart.request('key') }.should raise_error
  #end

  it "#request should work inside a callback" do
    FreeMart.register 'key', 'value'
    FreeMart.request('key').should == 'value'

    FreeMart.register 'key' do |_, *args|
      old_result = FreeMart.request 'key', *args
      if old_result == FreeMart::NOT_FOUND
        FreeMart::NOT_FOUND
      else
        "#{old_result} #{args.join(' ')}"
      end
    end
    FreeMart.request('key', 'a', 'b').should == 'value a b'
  end

  #it "#reregister and #request_no_error should return NOT_FOUND if not found" do
  #  FreeMart.register('key'){ FreeMart::NOT_FOUND }
  #  FreeMart.reregister 'key' do |*args|
  #    FreeMart.request_no_error 'key', *args
  #  end
  #  FreeMart.request_no_error('key').should == FreeMart::NOT_FOUND
  #end

  #it "#deregister and #reregister should work together" do
  #  old_provider = FreeMart.register 'key', 'old'
  #  new_provider = FreeMart.reregister 'key', 'new'
  #  FreeMart.request('key').should == 'new'
  #  FreeMart.deregister 'key', new_provider
  #  FreeMart.request('key').should == 'old'
  #end

  #it "#clear should work" do
  #  FreeMart.register 'key', 'value'
  #  FreeMart.clear
  #  lambda { FreeMart.request('key') }.should raise_error
  #end

  #it "#clear can take list of keys" do
  #  FreeMart.register 'a', 'aa'
  #  FreeMart.register 'b', 'bb'
  #  FreeMart.register 'c', 'cc'
  #  FreeMart.clear 'a', 'b'
  #  lambda { FreeMart.request('a') }.should raise_error
  #  lambda { FreeMart.request('b') }.should raise_error
  #  FreeMart.request('c').should == 'cc'
  #end

  #it "should support multiple providers for same key" do
  #  FreeMart.register('key') do |index|
  #    if index == 1
  #      'first'
  #    else
  #      FreeMart.not_found
  #    end
  #  end
  #  FreeMart.register('key') do |index|
  #    if index == 2
  #      'second'
  #    else
  #      FreeMart.not_found
  #    end
  #  end
  #  FreeMart.request('key', 1).should == 'first'
  #  FreeMart.request('key', 2).should == 'second'
  #  lambda { FreeMart.request('key', 3) }.should raise_error
  #end

  #it "collect results from multiple providers should work" do
  #  FreeMart.register 'key', 'a'
  #  FreeMart.register 'key', 'b'
  #  FreeMart.reregister 'key' do
  #    providers = FreeMart.providers['key']
  #    combined = []
  #    providers.each do |provider|
  #      result = provider.call
  #      if result != FreeMart::NOT_FOUND
  #        combined << result
  #      end
  #    end
  #    combined
  #  end
  #  FreeMart.request('key').should == ['a', 'b']
  #end

  #it "merge hashes from multiple providers should work" do
  #  FreeMart.register 'key', a: 'aa'
  #  FreeMart.register 'key', b: 'bb'
  #  FreeMart.reregister 'key' do
  #    providers = FreeMart.providers['key']
  #    combined = {}
  #    providers.each do |provider|
  #      result = provider.call
  #      if result != FreeMart::NOT_FOUND
  #        combined.merge! result
  #      end
  #    end
  #    combined
  #  end
  #  FreeMart.request('key').should == {a: 'aa', b: 'bb'}
  #end

  it "key arg can be symbol but is converted to string" do
    FreeMart.register :a, 'aa'
    FreeMart.request(:a).should  == 'aa'
    FreeMart.request('a').should == 'aa'
    FreeMart.register 'b', 'bb'
    FreeMart.request(:b).should  == 'bb'
    FreeMart.request('b').should == 'bb'
  end

  it "#accept? should work" do
    FreeMart.accept?(:a).should be_false
    FreeMart.register :b, 'bb'
    FreeMart.accept?(:b).should be_true
  end

  #it "#providers should work" do
  #  FreeMart.register :a, 'aa'
  #  FreeMart.providers.size.should == 1
  #  FreeMart.providers.should have_key 'a'
  #end

  #it "#provider_for should work" do
  #  FreeMart.provider_for(:a).should be_nil
  #  FreeMart.register :b, 'bb'
  #  FreeMart.provider_for(:b).should_not be_nil
  #end

  it "#requestMulti should work" do
    FreeMart.register 'key1', 'value1'
    FreeMart.register 'key2', 'value2'
    FreeMart.requestMulti('key1', 'key2').should == ['value1', 'value2']
  end

  it "#requestMulti should work if extra args are passed" do
    FreeMart.register('key1') {|_, *args| "value1 #{args.join(' ')}"}
    FreeMart.register 'key2', 'value2'
    FreeMart.requestMulti(['key1', 'a', 'b'], 'key2').should == ['value1 a b', 'value2']
  end

  it "#requestAll should work" do
    FreeMart.register 'key', 'first'
    FreeMart.register 'key', 'second'
    FreeMart.requestAll('key').should == ['first', 'second']
  end

end
