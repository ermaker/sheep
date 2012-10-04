require 'spec_helper'
require 'farm'
require 'sheep'
require 'algorithms/naive_with_kdtree'
require 'query'

describe 'Kdtree speed' do
  before do
    @farm = Farm.new
    @farm.sheep = Sheep.new
    @farm.sheep.load fixture('Nanaimo.map')
    @farm.set_algorithm Algorithms::NaiveWithKdtree
    @queries = Query.load fixture('Nanaimo_20_0.1_random.query')
  end

  it 'works' do
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
