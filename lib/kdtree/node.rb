module Kdtree
  class Node
    attr_reader :mbr

    def initialize *nodes
      @nodes = nodes
    end

    def calculate_mbr
      @nodes.each(&:calculate_mbr)
      mbr_array = @nodes.map(&:mbr)
      mbr = mbr_array.transpose
      @mbr = [mbr[0].min, mbr[1].min, mbr[2].max, mbr[3].max]
    end
  end
end
