require 'geometry'
require 'ext/geometry'

module Kdtree
  class LeafNode
    attr_reader :mbr

    def initialize object
      @object = object
    end

    def calculate_mbr
      x = @object.map{|v|v[0]}
      y = @object.map{|v|v[1]}
      minx = x.min
      miny = y.min
      maxx = x.max
      maxy = y.max
      @mbr = [minx, miny, maxx, maxy]
    end

    def query minx, miny, maxx, maxy
      query_area = Polygon [
        Point(minx, miny),
        Point(maxx, miny),
        Point(maxx, maxy),
        Point(minx, maxy),
      ]
      Polygon(@object.map{|p|Geometry::Point.new_by_array(p)}).
        counting?(query_area) ? 1 : 0
    end
  end
end
