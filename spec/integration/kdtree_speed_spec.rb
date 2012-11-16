require 'spec_helper'
require 'farm'
require 'sheep'
require 'algorithms/naive_with_kdtree'
require 'query'

describe 'Kdtree speed' do
  before(:all) do
    @farm = Farm.new
    @farm.sheep = Sheep.new
    @farm.sheep.load fixture('Nanaimo.map')
    @farm.set_algorithm Algorithms::NaiveWithKdtree
    @queries = Query.load(fixture('Nanaimo_20_0.1_random.query')){|q|q}
    @node = @farm.instance_variable_get(:@algorithm).
      instance_variable_get(:@kdtree)
  end

  it 'works' do
    @node.calculate_mbr
    expect do
      sel = @farm.query *@queries.first
    end.to change{Time.now}.by_at_most(0.01*4)
  end

  it 'works on 20 queries' do
    @node.calculate_mbr
    expect do
      sel = @queries.map {|query| @farm.query(*query)}
    end.to change{Time.now}.by_at_most(0.2*3)
  end
end
