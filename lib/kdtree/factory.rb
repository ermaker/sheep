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
  end
end
