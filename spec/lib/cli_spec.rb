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

  context '.make_hist' do
    it 'works with :histogram' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.map'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.map'))))
      File.stub(:open).with(fixture('3_0.001_histogram.hist'), 'w').and_yield(result)
      memory = 0.001
      method = :histogram
      described_class.make_hist fixture('3.map'), memory, method
      result.string.split("\n").reject {|v| v.include? 'sheep: '}.should ==
        File.read(fixture('3_0.001_histogram.hist')).split("\n").reject {|v| v.include? 'sheep: '}
    end

    it 'works with :simple' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.map'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.map'))))
      File.stub(:open).with(fixture('3_0.001_simple.hist'), 'w').and_yield(result)
      memory = 0.001
      method = :simple
      described_class.make_hist fixture('3.map'), memory, method
      result.string.split("\n").
        reject {|v| v.include? '- *' or v.include? '- &'}.should ==
        File.read(fixture('3_0.001_simple.hist')).split("\n").
        reject {|v| v.include? '- *' or v.include? '- &'}
    end
  end

  context '.make_makefile' do
    it 'works' do
      data = [fixture('3.data')]
      number = [100]
      memory = [0.001, 0.005, 0.01]
      method = [:histogram, :simple]
      area = [0.01, 0.05, 0.1]
      dist = [:random]
      measure = [:absolute]
      described_class.make_makefile data, number, memory, method, area, dist, measure
    end
  end
end
