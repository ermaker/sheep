require 'geometry'
require 'ext/geometry'

module Algorithms
  class Naive
    attr_accessor :objects

    def initialize sheep
      @objects = sheep.objects
    end

    def query minx, miny, maxx, maxy
      query_area = Polygon [
        Point(minx, miny),
        Point(maxx, miny),
        Point(maxx, maxy),
        Point(minx, maxy),
      ]
      @objects.count do |obj|
        Polygon(obj.map{|p|Geometry::Point.new_by_array(p)}).
          counting?(query_area)
      end
    end
  end
end
