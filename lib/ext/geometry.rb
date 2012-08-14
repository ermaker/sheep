module Geometry
  class Polygon
    def intersects_with? segment
      edges.any? {|edge| edge.intersects_with? segment}
    end
  end
end
