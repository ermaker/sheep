require 'algorithms/simple'
require 'sheep'

describe Algorithms::Simple do
  subject do
    sheep = Sheep.new
    sheep.objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    described_class.new(sheep, 2, 2, 2)
  end

  context '#query' do
    it 'works' do
      pending
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
    end
  end
end
