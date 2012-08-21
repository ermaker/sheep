require 'spec_helper'
require 'farm'
require 'stringio'

describe Farm do
  context '.convert' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.data'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.data'))))
      File.stub(:open).with(tmp('3.map'), 'w').and_yield(result)
      described_class.convert fixture('3.data'), tmp('3.map'), StringIO.new
      result.string.should == File.read(fixture('3.map'))
    end
  end
end
