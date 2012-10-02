require 'kdtree/leaf_node'

describe Kdtree::LeafNode do
  before do
    @objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    @leaf_nodes = @objects.map {|object| described_class.new(object)}
  end

  context '#mbr' do
    it 'works' do
      mbr = [
        [2.0, 1.0, 4.0, 6.0],
        [1.0, 5.0, 5.0, 7.0],
        [4.0, 2.0, 5.0, 3.0],
      ]
      @leaf_nodes.zip(mbr).map do |leaf_node,mbr|
        leaf_node.calculate_mbr
        leaf_node.mbr.should == mbr
      end
    end
  end
end
