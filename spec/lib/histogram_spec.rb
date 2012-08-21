require 'histogram'

describe Histogram do
  subject do
    Histogram.new [
      [1, -1, 2],
      [-1, 1, -1],
      [2, -2, 2],
    ], 0.0, 0.0, 6.0, 8.0, 2, 2
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
  end
end
