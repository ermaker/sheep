require 'spec_helper'
require 'farm'
require 'algorithms/naive'
require 'algorithms/histogram'
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

  context '#set_algorithm' do
    it 'works on Algorithms::Naive' do
      subject.sheep = double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ])
      subject.set_algorithm Algorithms::Naive
    end

    it 'works on Algorithms::Histogram' do
      subject.sheep = double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ],
        :euler_histogram => [
          [1, -1, 2],
          [-1, 1, -1],
          [2, -2, 2],
      ],
      :minx => 0.0, :miny => 0.0, :maxx => 6.0, :maxy => 8.0)

      subject.set_algorithm Algorithms::Histogram, 2, 2
    end
  end

  context '#query' do
    it 'works on Algorithms::Naive' do
      subject.sheep = double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ])
      subject.set_algorithm Algorithms::Naive

      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1
      subject.query(3.0, 5.0, 4.0, 6.0).should == 2
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 3
    end

    it 'works on Algorithms::Histogram' do
      subject.sheep = double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ],
        :euler_histogram => [
          [1, -1, 2],
          [-1, 1, -1],
          [2, -2, 2],
      ],
      :minx => 0.0, :miny => 0.0, :maxx => 6.0, :maxy => 8.0)
      subject.set_algorithm Algorithms::Histogram, 2, 2

      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1.0/6.0
      subject.query(3.0, 5.0, 4.0, 6.0).should == 1.0/6.0
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2.0/3.0
      subject.query(4.0, 4.0, 5.0, 5.0).should == 1.0/6.0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 1.0
    end
  end
end
