require 'algorithms/histogram'
require 'sheep'

describe Algorithms::Histogram do
  subject do
    described_class.new(
      double(
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
    :minx => 0.0, :miny => 0.0, :maxx => 6.0, :maxy => 8.0), 2, 2)
  end

  context '#bounds' do
    it 'works' do
      subject.bounds(0.0, 0.0, 6.0, 8.0).should == [
        [0, 0, 2, 2],
        [0, 0, 2, 2],
        [0.0, 0.0, 8.0, 6.0],
        [0.0, 0.0, 8.0, 6.0],
      ]
      subject.bounds(4.0, 2.0, 5.0, 3.0).should == [
        [1, 2, 0, 1],
        [0, 1, 1, 2],
        [4.0, 6.0, 0.0, 3.0],
        [0.0, 3.0, 4.0, 6.0],
      ]
      subject.bounds(3.0, 5.0, 4.0, 6.0).should == [
        [2, 1, 1, 1],
        [1, 1, 2, 2],
        [8.0, 3.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(3.0, 4.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [1, 1, 2, 2],
        [4.0, 3.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(4.0, 4.0, 5.0, 5.0).should == [
        [1, 2, 1, 1],
        [1, 1, 2, 2],
        [4.0, 6.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(3.0, 2.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [0, 1, 2, 2],
        [4.0, 3.0, 4.0, 3.0],
        [0.0, 3.0, 8.0, 6.0],
      ]
    end

    it 'works with special cases' do
      subject.bounds(-100.0, -100.0, 100.0, 100.0).should == [
        [0, 0, 2, 2],
        [0, 0, 2, 2],
        [0.0, 0.0, 8.0, 6.0],
        [0.0, 0.0, 8.0, 6.0],
      ]
      subject.bounds(-100.0, -100.0, -50.0, -50.0).should == [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0.0, 0.0, 0.0, 0.0],
        [0.0, 0.0, 0.0, 0.0],
      ]
      subject.bounds(3.0, -10.0, 10.0, 50.0).should == [
        [0, 1, 2, 2],
        [0, 1, 2, 2],
        [0.0, 3.0, 8.0, 6.0],
        [0.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(7.0, 9.0, 9.0, 11.0).should == [
        [2, 2, 2, 2],
        [2, 2, 2, 2],
        [8.0, 6.0, 8.0, 6.0],
        [8.0, 6.0, 8.0, 6.0],
      ]
    end
  end

  context '#exact_query' do
    it 'works' do
      subject.exact_query(0, 0, 1, 1).should == 1
      subject.exact_query(0, 0, 1, 2).should == 2
      subject.exact_query(0, 0, 2, 1).should == 2
      subject.exact_query(0, 0, 2, 2).should == 3
      subject.exact_query(0, 1, 1, 2).should == 2
      subject.exact_query(0, 1, 2, 2).should == 3
      subject.exact_query(1, 0, 2, 1).should == 2
      subject.exact_query(1, 0, 2, 2).should == 2
      subject.exact_query(1, 1, 2, 2).should == 2
    end

    it 'works with special cases' do
      subject.exact_query(0, 0, 0, 0).should == 0
      subject.exact_query(1, 1, 1, 1).should == 0
      subject.exact_query(0, 1, 1, 1).should == 0
      subject.exact_query(1, 0, 1, 1).should == 0
      subject.exact_query(1, 1, 0, 0).should == 0
      subject.exact_query(1, 0, 0, 0).should == 0
      subject.exact_query(0, 1, 0, 0).should == 0
    end
  end

  context '#area' do
    it 'works' do
      subject.area(0.0, 0.0, 6.0, 8.0).should == 48.0
      subject.area(4.0, 2.0, 5.0, 3.0).should == 1.0
      subject.area(3.0, 5.0, 4.0, 6.0).should == 1.0
      subject.area(3.0, 4.0, 5.0, 6.0).should == 4.0
      subject.area(4.0, 4.0, 5.0, 5.0).should == 1.0
      subject.area(3.0, 2.0, 5.0, 6.0).should == 8.0
    end

    it 'works with special cases' do
      subject.area(0.0, 0.0, 0.0, 0.0).should == 0.0
      subject.area(0.0, 0.0, 1.0, 0.0).should == 0.0
      subject.area(0.0, 0.0, 0.0, 1.0).should == 0.0
      subject.area(1.0, 1.0, 0.0, 0.0).should == 0.0
      subject.area(1.0, 0.0, 0.0, 0.0).should == 0.0
      subject.area(0.0, 1.0, 0.0, 0.0).should == 0.0
      subject.area(1.0, 0.0, 0.0, 1.0).should == 0.0
      subject.area(0.0, 1.0, 1.0, 0.0).should == 0.0
    end
  end

  context '#query' do
    it 'works' do
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1.0/6.0
      subject.query(3.0, 5.0, 4.0, 6.0).should == 1.0/6.0
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2.0/3.0
      subject.query(4.0, 4.0, 5.0, 5.0).should == 1.0/6.0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 1.0
    end

    it 'works with special cases' do
      subject.query(-100.0, -100.0, 100.0, 100.0).should == 3
      subject.query(-100.0, -100.0, -50.0, -50.0).should == 0
      subject.query(3.0, -10.0, 10.0, 50.0).should == 3
      subject.query(7.0, 9.0, 9.0, 11.0).should == 0

      subject.query(4.0, 4.0, 6.0, 8.0).should == 1.3333333333333333
      subject.query(4.0, 4.0, 100.0, 100.0).should == 1.3333333333333333
    end
  end
end

describe Algorithms::Histogram, 'with special objects' do
  subject do
    s = Sheep.new
    s.objects = [
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
    ]
    described_class.new(s, 2, 2)
  end

  context '#query' do
    it 'works' do
      subject.query(4.0, 2.0, 5.0, 3.0).should_not be_nan
      subject.query(4.0, 2.0, 5.0, 3.0).should == 0.0
    end
  end
end
