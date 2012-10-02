require 'kdtree/factory'

describe Kdtree::Factory do
  before do
    @objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
  end

  context '.make' do
    it 'works with an object' do
      mbr = [
        [2.0, 1.0, 4.0, 6.0],
        [1.0, 5.0, 5.0, 7.0],
        [4.0, 2.0, 5.0, 3.0],
      ]
      leaf_nodes = @objects.map do |object|
        Kdtree::Factory.make([object])
      end
      leaf_nodes.map(&:mbr).should == mbr
    end

    it 'works with an object' do
      mbr = [
        [1.0, 1.0, 5.0, 7.0],
        [2.0, 1.0, 5.0, 6.0],
        [1.0, 2.0, 5.0, 7.0],
      ]
      nodes = @objects.combination(2).map do |objects|
        Kdtree::Factory.make objects
      end
      nodes.map(&:mbr).should == mbr
    end
  end
end
