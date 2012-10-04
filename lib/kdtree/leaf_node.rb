require 'geometry'
require 'ext/geometry'

module Kdtree
  class LeafNode
    attr_reader :mbr
    attr_reader :object

    def initialize object
      @object = object
      calculate_mbr
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
      return 0 unless (@mbr[0] > minx ? @mbr[0] : minx) <= (@mbr[2] < maxx ? @mbr[2] : maxx) and (@mbr[1] > miny ? @mbr[1] : miny) <= (@mbr[3] < maxy ? @mbr[3] : maxy)

      $clipper ||= Clipper::Clipper.new
      $clipper.clear!
      $clipper.add_subject_polygon(@object)
      $clipper.add_clip_polygon([[minx,miny],[maxx,miny],[maxx,maxy],[minx,maxy]])
      $clipper.intersection.empty? ? 0 : 1
    end
  end
end
