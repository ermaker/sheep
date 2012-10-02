require 'kdtree/node'
require 'kdtree/leaf_node'

describe Kdtree::Node do
  before do
    @objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
    ]
    @leaf_nodes = @objects.map{|object| Kdtree::LeafNode.new(object)}
    @nodes = @leaf_nodes.each_slice(2).map do |nodes|
      described_class.new(*nodes)
    end
    @node = described_class.new(*@nodes)
  end

  context '#mbr' do
    it 'works' do
      mbr = [
        [1.0, 1.0, 5.0, 7.0],
        [1.0, 2.0, 5.0, 7.0],
      ]
      @nodes.zip(mbr).map do |node,mbr|
        node.calculate_mbr
        node.mbr.should == mbr
      end

      @node.calculate_mbr
      @node.mbr.should == [1.0, 1.0, 5.0, 7.0]
    end
  end

  context '#query' do
    it 'works' do
      queries = [
        [0.0, 0.0, 1.0, 1.0],
        [1.0, 1.0, 4.0, 4.0],
        [3.0, 3.0, 6.0, 6.0],
        [3.0, 1.0, 6.0, 3.0],
      ]
      expected = [0, 1, 3, 2]
      result = queries.map do |query|
        @node.query *query
      end
      result.should == expected
    end
  end
end
