require 'kdtree/node'
require 'kdtree/leaf_node'

describe Kdtree::Node do
  context '#mbr' do
    it 'works' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      ]
      leaf_nodes = objects.map{|object| Kdtree::LeafNode.new(object)}
      mbr = [
        [1.0, 1.0, 5.0, 7.0],
        [1.0, 2.0, 5.0, 7.0],
      ]
      nodes = leaf_nodes.each_slice(2).zip(mbr).map do |nodes,mbr|
        node = described_class.new(*nodes)
        node.calculate_mbr
        node.mbr.should == mbr
        node
      end

      node = described_class.new(*nodes)
      node.calculate_mbr
      node.mbr.should == [1.0, 1.0, 5.0, 7.0]
    end
  end
end
