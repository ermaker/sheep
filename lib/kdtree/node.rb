require 'geometry'
require 'ext/geometry'

module Kdtree
  class Node
    attr_reader :mbr
    attr_reader :nodes

    def initialize *nodes
      @nodes = nodes
      calculate_mbr
    end

    def calculate_mbr
      mbr_array = @nodes.map(&:mbr)
      mbr = mbr_array.transpose
      @mbr = [mbr[0].min, mbr[1].min, mbr[2].max, mbr[3].max]
    end

    def query minx, miny, maxx, maxy
      return 0 unless (@mbr[0] > minx ? @mbr[0] : minx) <= (@mbr[2] < maxx ? @mbr[2] : maxx) and (@mbr[1] > miny ? @mbr[1] : miny) <= (@mbr[3] < maxy ? @mbr[3] : maxy)

      return @nodes[0].query(minx, miny, maxx, maxy)+
        @nodes[1].query(minx, miny, maxx, maxy)
=begin
      return @nodes.inject(0) do |result,node|
        result += node.query minx, miny, maxx, maxy
      end
=end
    end
  end
end
