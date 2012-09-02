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

  context '.make_query' do
    it 'works' do
      srand 0
      result = StringIO.new
      File.stub(:open).with(fixture('3.map'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.map'))))
      File.stub(:open).with(fixture('3_10_0.01_random.query'), 'w').and_yield(result)
      number = 10
      area = 0.01
      dist = :random
      described_class.make_query fixture('3.map'), number, area, dist
      result.string.should == File.read(fixture('3_10_0.01_random.query'))
    end
  end
end
