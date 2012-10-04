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
      return 0 unless [mbr[0], minx].max <= [mbr[2], maxx].min and [mbr[1], miny].max <= [mbr[3], maxy].min

      return @nodes.map {|node| node.query minx, miny, maxx, maxy}.inject(:+)
    end
  end
end
