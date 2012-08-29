require 'spec_helper'
require 'sheep'
require 'query'

describe Query do
  context '.generate' do
    it 'works' do
      sheep = Sheep.new
      sheep.load fixture('3.map')
      area = 0.01
      10000.times do
        query = Query.generate sheep, area
        query.should be_an Array
        query.should have(4).items
        query[0].should >= sheep.minx
        query[1].should <= sheep.maxx
        query[2].should >= sheep.miny
        query[3].should <= sheep.maxy
        query[0].should < query[2]
        query[1].should < query[3]
        ((query[2]-query[0]) * (query[3]-query[1])).should be_within(0.00000001).of((sheep.maxx-sheep.minx)*(sheep.maxy-sheep.miny)*area)
      end
    end
  end
end
