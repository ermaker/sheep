module Geometry
  class Polygon
    def inside? point
      point_in_polygon = PointInPolygon.new(point, self)
      point_in_polygon.inside?
    end
    def intersects_with? segment
      edges.any? {|edge| edge.intersects_with? segment}
    end
    def counting? point_or_segment
      case point_or_segment
      when Point
        inside? point_or_segment
      when Segment
        intersects_with? point_or_segment
      else
        raise
      end
    end
  end
end
