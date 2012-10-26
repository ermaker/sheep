require 'spec_helper'
require 'query'
require 'farm'
require 'sheep'
require 'algorithms/naive'
require 'algorithms/histogram'

describe 'One step' do
  it 'works on Algorithms::Naive' do
    farm = Farm.new
    farm.sheep = Sheep.new
    farm.sheep.load fixture('3.map')
    area = 0.01
    queries = 10.times.map { Query.generate farm.sheep, area }
    farm.set_algorithm Algorithms::Naive
    result = queries.map do |query|
      farm.query *query
    end
  end

  it 'works on Algorithms::Histogram' do
    farm = Farm.new
    farm.sheep = Sheep.new
    farm.sheep.load fixture('3.map')
    area = 0.01
    queries = 10.times.map { Query.generate farm.sheep, area }
    farm.set_algorithm Algorithms::Histogram, 4, 4
    farm.data StringIO.new
    result = queries.map do |query|
      farm.query *query
    end
  end
end
