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
      ]
      subject.bounds(4.0, 2.0, 5.0, 3.0).should == [
        [1, 2, 0, 1],
        [0, 1, 1, 2],
      ]
      subject.bounds(3.0, 5.0, 4.0, 6.0).should == [
        [2, 1, 1, 1],
        [1, 1, 2, 2],
      ]
      subject.bounds(3.0, 4.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [1, 1, 2, 2],
      ]
      subject.bounds(4.0, 4.0, 5.0, 5.0).should == [
        [1, 2, 1, 1],
        [1, 1, 2, 2],
      ]
      subject.bounds(3.0, 2.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [0, 1, 2, 2],
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
  end

  context '#query' do
    it 'works' do
      pending
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1
      subject.query(3.0, 5.0, 4.0, 6.0).should == 2
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 3
    end
  end
end
