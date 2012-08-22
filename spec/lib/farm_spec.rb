require 'spec_helper'
require 'farm'
require 'algorithms/naive'
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

  context '#algorithm=' do
    it 'works on Algorithms::Naive' do
      subject.sheep = double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ])
      subject.algorithm=Algorithms::Naive
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
      subject.algorithm=Algorithms::Naive
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1
      subject.query(3.0, 5.0, 4.0, 6.0).should == 2
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 3
    end
  end
end
