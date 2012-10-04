require 'spec_helper'
require 'farm'
require 'sheep'
require 'algorithms/naive_with_kdtree'
require 'query'

module Kdtree
  class Node
    def depth
      @nodes.map(&:depth).max + 1
    end
  end
  class LeafNode
    def depth
      1
    end
    alias _query query
    def query minx, miny, maxx, maxy
      return 0 unless [mbr[0], minx].max <= [mbr[2], maxx].min and [mbr[1], miny].max <= [mbr[3], maxy].min
      $count += 1
      _query minx, miny, maxx, maxy
    end
  end
end

describe 'Kdtree speed' do
  before do
    @farm = Farm.new
    @farm.sheep = Sheep.new
    @farm.sheep.load fixture('Nanaimo.map')
    @farm.set_algorithm Algorithms::NaiveWithKdtree
    @queries = Query.load fixture('Nanaimo_20_0.1_random.query')
  end

  it 'works' do
    node = @farm.instance_variable_get(:@algorithm).
      instance_variable_get(:@kdtree)
    node.depth.should == 16
    $count = 0
    sel = @farm.query *@queries.first

    @farm.sheep.objects.should have(25755).items
    sel.should == 237
    $count.should == 4536
  end

  it 'works', :if => false do
    expect do
      sel = @farm.query *@queries.first
    end.to change{Time.now}.by_at_most(0.01)
  end

  it 'works on 20 queries', :if => false do
    expect do
      sel = @queries.map {|query| @farm.query(*query)}
    end.to change{Time.now}.by_at_most(0.2)
  end
end
