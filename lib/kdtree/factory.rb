require 'kdtree/node'
require 'kdtree/leaf_node'

module Kdtree
  class Factory
    def self.make objects
      _make objects, 0
    end
    def self._make objects, axis
      return LeafNode.new objects.first if objects.one?
      next_axis = axis == 0 ? 1 : 0
      sorted_objects = objects.sort_by do |object|
        points = object.map {|point| point[axis]}
        points.inject(:+)/points.size
      end
      input_objects = [
        _make(sorted_objects[0...sorted_objects.size/2], next_axis),
        _make(sorted_objects[sorted_objects.size/2..-1], next_axis),
      ]
      return Node.new *input_objects
    end

    def self.query kdtree, minx, miny, maxx, maxy
      polygon = [[minx,miny],[maxx,miny],[maxx,maxy],[minx,maxy]]
      $clipper ||= Clipper::Clipper.new
      result = 0
      q = [kdtree]
      until q.empty?
        now = q.pop
        now_mbr = now.mbr
        next unless (now_mbr[0] > minx ? now_mbr[0] : minx) <= (now_mbr[2] < maxx ? now_mbr[2] : maxx) and (now_mbr[1] > miny ? now_mbr[1] : miny) <= (now_mbr[3] < maxy ? now_mbr[3] : maxy)
        case now
        when Node
          q.push *now.nodes
        when LeafNode
          $clipper.clear!
          $clipper.add_subject_polygon(now.object)
          $clipper.add_clip_polygon(polygon)
          result += 1 unless $clipper.intersection.empty?
        end
      end
      return result
    end
  end
end
