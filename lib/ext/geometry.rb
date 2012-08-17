require 'clipper'

module Geometry
  class Polygon
    def inside? point
      point_in_polygon = PointInPolygon.new(point, self)
      point_in_polygon.inside?
    end
    def intersects_with? segment
      edges.any? do |edge|
        edge.intersects_with?(segment) and
        not [edge.point1, edge.point2].any?{|p| segment.contains_point?(p)} and
        not [segment.point1, segment.point2].any?{|p| edge.contains_point?(p)}
      end or
      [segment.point1, segment.point2, Point(
        (segment.point1.x+segment.point2.x)/2,
        (segment.point1.y+segment.point2.y)/2)
      ].
        any? {|p| inside?(p)}
    end
    def to_a
      vertices.map{|point| [point.x, point.y]}
    end
    def counting? point_or_segment_or_cell
      case point_or_segment_or_cell
      when Point
        inside? point_or_segment_or_cell
      when Segment
        intersects_with? point_or_segment_or_cell
      when Polygon
        clipper = Clipper::Clipper.new
        clipper.add_subject_polygon to_a
        clipper.add_clip_polygon point_or_segment_or_cell.to_a
        not clipper.intersection.empty?
      else
        raise
      end
    end
  end
end
