require 'kdtree/leaf_node'

describe Kdtree::LeafNode do
  context '#mbr' do
    it 'works' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      mbr = [
        [2.0, 1.0, 4.0, 6.0],
        [1.0, 5.0, 5.0, 7.0],
        [4.0, 2.0, 5.0, 3.0],
      ]
      objects.zip(mbr).map do |object,mbr|
        leaf_node = described_class.new(object)
        leaf_node.calculate_mbr
        leaf_node.mbr.should == mbr
      end
    end
  end
end
