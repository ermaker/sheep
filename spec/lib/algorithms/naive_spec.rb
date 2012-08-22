require 'algorithms/naive'

describe Algorithms::Naive do
  subject do 
    described_class.new double(
      :objects => [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    )
  end
  context '#query' do
    it 'works' do
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1
      subject.query(3.0, 5.0, 4.0, 6.0).should == 2
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 3
    end
  end
end
