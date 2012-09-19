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
  end
end
