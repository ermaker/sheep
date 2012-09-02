require 'spec_helper'
require 'cli'

describe CLI do
  context '.make_map' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.data'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.data'))))
      File.stub(:open).with(fixture('3.map'), 'w').and_yield(result)
      described_class.make_map fixture('3.data'), StringIO.new
      result.string.should == File.read(fixture('3.map'))
    end
  end
end
