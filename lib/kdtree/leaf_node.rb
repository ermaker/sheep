require 'geometry'
require 'ext/geometry'

module Kdtree
  class LeafNode
    def mbr
      @mbr ||= calculate_mbr
    end

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
      return 0 unless [mbr[0], minx].max <= [mbr[2], maxx].min and [mbr[1], miny].max <= [mbr[3], maxy].min

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
