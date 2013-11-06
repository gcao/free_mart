require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FreeMart" do
  it "should work" do
    FreeMart.register 'name', 'John Doe'
    FreeMart.request('name').should == 'John Doe'
  end
end
