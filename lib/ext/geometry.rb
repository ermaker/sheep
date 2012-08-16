module Geometry
  class Polygon
    def inside? point
      point_in_polygon = PointInPolygon.new(point, self)
      point_in_polygon.inside?
    end
    def intersects_with? segment
      edges.any? {|edge| edge.intersects_with? segment}
    end
    def counting? point
      inside? point
    end
  end
end
