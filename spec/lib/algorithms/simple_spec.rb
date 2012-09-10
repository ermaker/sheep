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

  context '#histograms' do
    it 'works' do
      subject.histograms.should have(2).items
      subject.histograms[0].query(0.0, 0.0, 6.0, 8.0).should == 2
      subject.histograms[1].query(0.0, 0.0, 6.0, 8.0).should == 1
    end
  end

  context '#query' do
    it 'works' do
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 0.5333333333333333
      subject.query(3.0, 5.0, 4.0, 6.0).should == 0.6333333333333333
      subject.query(3.0, 4.0, 5.0, 6.0).should == 1.5333333333333332
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0.26666666666666666
      subject.query(3.0, 2.0, 5.0, 6.0).should == 2.3777777777777778
    end

    it 'works with special cases' do
      subject.query(-100.0, -100.0, 100.0, 100.0).should == 3
      subject.query(-100.0, -100.0, -50.0, -50.0).should == 0
      subject.query(3.0, -10.0, 10.0, 50.0).should == 3
      subject.query(7.0, 9.0, 9.0, 11.0).should == 0
    end
  end
end

describe Algorithms::Simple, 'with special objects' do
  subject do
    sheep = Sheep.new
    sheep.objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    described_class.new(sheep, 3, 2, 2)
  end

  context '#histograms' do
    it 'works' do
      subject.histograms.should have(3).items
      subject.histograms[0].query(0.0, 0.0, 6.0, 8.0).should == 1
      subject.histograms[1].query(0.0, 0.0, 6.0, 8.0).should == 1
      subject.histograms[2].query(0.0, 0.0, 6.0, 8.0).should == 1
    end
  end

  context '#query' do
    it 'works' do
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1.0
      subject.query(3.0, 5.0, 4.0, 6.0).should == 0.9
      subject.query(3.0, 4.0, 5.0, 6.0).should == 1.8
      subject.query(4.0, 4.0, 5.0, 5.0).should == 0.0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 3.0
    end

    it 'works with special cases' do
      subject.query(-100.0, -100.0, 100.0, 100.0).should == 3
      subject.query(-100.0, -100.0, -50.0, -50.0).should == 0
      subject.query(3.0, -10.0, 10.0, 50.0).should == 3
      subject.query(7.0, 9.0, 9.0, 11.0).should == 0
    end
  end
end

describe Algorithms::Simple, 'with memory size' do
  subject do
    sheep = Sheep.new
    sheep.objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    described_class.new(sheep, 1024)
  end

  it 'has the correct size' do
    subject.histograms.should have(6).items
    subject.histograms.each do |histogram|
      histogram.stepx.should == 2
      histogram.stepy.should == 2
    end
  end
end
