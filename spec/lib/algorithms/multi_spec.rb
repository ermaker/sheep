require 'spec_helper'
require 'algorithms/multi'
require 'farm'
require 'stringio'

describe Algorithms::Multi do
  subject do
    farm = Farm.new
    farm.sheep = Sheep.new
    farm.sheep.load fixture('Nanaimo.map')
    farm.set_algorithm described_class, 1024, StringIO.new
    farm.data StringIO.new
    farm
  end

  it 'works' do
    subject
  end

  context '#query' do
    it 'works' do
      pending
      subject.query(0.0, 0.0, 6.0, 8.0).should == nil
      subject.query(4.0, 2.0, 5.0, 3.0).should == nil
      subject.query(3.0, 5.0, 4.0, 6.0).should == nil
      subject.query(3.0, 4.0, 5.0, 6.0).should == nil
      subject.query(4.0, 4.0, 5.0, 5.0).should == nil
      subject.query(3.0, 2.0, 5.0, 6.0).should == nil
    end

    it 'works with special cases' do
      pending
      subject.query(-100.0, -100.0, 100.0, 100.0).should == nil
      subject.query(-100.0, -100.0, -50.0, -50.0).should == nil
      subject.query(3.0, -10.0, 10.0, 50.0).should == nil
      subject.query(7.0, 9.0, 9.0, 11.0).should == nil
    end
  end
end
