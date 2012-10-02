require 'geometry'
require 'ext/geometry'

module Kdtree
  class Node
    def mbr
      @mbr ||= calculate_mbr
    end

    def initialize *nodes
      @nodes = nodes
    end

    def calculate_mbr
      @nodes.each(&:calculate_mbr)
      mbr_array = @nodes.map(&:mbr)
      mbr = mbr_array.transpose
      @mbr = [mbr[0].min, mbr[1].min, mbr[2].max, mbr[3].max]
    end

    def query minx, miny, maxx, maxy
      query_area = Polygon [
        Point(minx, miny),
        Point(maxx, miny),
        Point(maxx, maxy),
        Point(minx, maxy),
      ]
      mbr_area = Polygon [
        Point(mbr[0], mbr[1]),
        Point(mbr[2], mbr[1]),
        Point(mbr[2], mbr[3]),
        Point(mbr[0], mbr[3]),
      ]
      return 0 unless mbr_area.counting?(query_area)

      return @nodes.map {|node| node.query minx, miny, maxx, maxy}.inject(:+)
    end
  end
end
