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

      clipper = Clipper::Clipper.new
      clipper.add_subject_polygon(@object)
      clipper.add_clip_polygon([[minx,miny],[maxx,miny],[maxx,maxy],[minx,maxy]])
      clipper.intersection.empty? ? 0 : 1
    end
  end
end
