require 'spec_helper'
require 'cli'
require 'stringio'

describe CLI do
  context '.make_data' do
    it 'works' do
      srand 0
      result = StringIO.new
      File.stub(:open).with(fixture('map100.map'), 'w').and_yield(result)
      described_class.make_data fixture('map100.map'), 100
      result.string.should == File.read(fixture('map100.map'))
    end
  end

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
      File.stub(:open).with(fixture('3_16_histogram.hist'), 'w').and_yield(result)
      memory = 16
      method = :histogram
      described_class.make_hist fixture('3.map'), memory, method, StringIO.new
      result.string.split("\n").reject {|v| v.include? 'sheep: '}.should ==
        File.read(fixture('3_16_histogram.hist')).split("\n").reject {|v| v.include? 'sheep: '}
    end

    it 'works with :simple' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.map'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.map'))))
      File.stub(:open).with(fixture('3_16_simple.hist'), 'w').and_yield(result)
      memory = 16
      method = :simple
      described_class.make_hist fixture('3.map'), memory, method, StringIO.new
      result.string.split("\n").
        reject {|v| v.include? '- *' or v.include? '- &'}.should ==
        File.read(fixture('3_16_simple.hist')).split("\n").
        reject {|v| v.include? '- *' or v.include? '- &'}
    end
  end

  context '.make_sel' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.map'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3.map'))))
      File.stub(:open).with(fixture('3_10_0.01_random.query')).and_yield(
        StringIO.new(File.read(fixture('3_10_0.01_random.query'))))
      File.stub(:open).with(fixture('3_10_0.01_random.sel'), 'w').and_yield(result)
      described_class.make_sel fixture('3_10_0.01_random.query'), StringIO.new
      result.string.should == File.read(fixture('3_10_0.01_random.sel'))
    end
  end

  context '.make_est' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3_16_histogram.hist'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_16_histogram.hist'))))
      File.stub(:open).with(fixture('3_10_0.01_random.query')).and_yield(
        StringIO.new(File.read(fixture('3_10_0.01_random.query'))))
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random.est'), 'w').and_yield(result)
      described_class.make_est fixture('3_16_histogram.hist'), fixture('3_10_0.01_random.query'), StringIO.new
      result.string.should ==
        File.read(fixture('3_16_histogram_10_0.01_random.est'))
    end
  end

  context '.make_err' do
    it 'works on absolute' do
      result = StringIO.new
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random.est'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_16_histogram_10_0.01_random.est'))))
      File.stub(:open).with(fixture('3_10_0.01_random.sel'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_10_0.01_random.sel'))))
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random_absolute.err'), 'w').and_yield(result)
      described_class.make_err fixture('3_16_histogram_10_0.01_random.est'), :absolute
      result.string.should ==
        File.read(fixture('3_16_histogram_10_0.01_random_absolute.err'))
    end

    it 'works on relative' do
      result = StringIO.new
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random.est'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_16_histogram_10_0.01_random.est'))))
      File.stub(:open).with(fixture('3_10_0.01_random.sel'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_10_0.01_random.sel'))))
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random_relative.err'), 'w').and_yield(result)
      described_class.make_err fixture('3_16_histogram_10_0.01_random.est'), :relative
      result.string.should ==
        File.read(fixture('3_16_histogram_10_0.01_random_relative.err'))
    end
  end

  context '.make_avg' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random_relative.err'), 'rt').and_yield(
        StringIO.new(File.read(fixture('3_16_histogram_10_0.01_random_relative.err'))))
      File.stub(:open).with(fixture('3_16_histogram_10_0.01_random_relative.err.avg'), 'w').and_yield(result)
      described_class.make_avg fixture('3_16_histogram_10_0.01_random_relative.err')
      result.string.should ==
        File.read(fixture('3_16_histogram_10_0.01_random_relative.err.avg'))
    end
  end

  context '.make_makefile' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with('Makefile', 'w').and_yield(result)
      data = [fixture('3.data')]
      number = [100]
      memory = [4, 8, 16]
      method = [:histogram, :simple]
      area = [0.01, 0.05, 0.1]
      dist = [:random]
      measure = [:absolute, :relative]
      described_class.make_makefile data, number, memory, method, area, dist, measure
      result.string.should == File.read(fixture('Makefile'))
    end
  end
end
