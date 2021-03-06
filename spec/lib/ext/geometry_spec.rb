require 'geometry'
require 'ext/geometry'

describe Geometry::Point do
  it 'works' do
    point = Point(1.0, 2.0)
    point.x.should == 1.0
    point.y.should == 2.0
  end
end

describe Geometry::Segment do
  subject do
    Segment(Point(0.0, 0.0), Point(1.0, 0.0))
  end

  it 'works' do
    segment = Segment(Point(0.0, 0.0), Point(0.0, 1.0))
    segment2 = Segment(Point(0.5, -0.5), Point(0.5, 0.5))

    (subject.intersects_with?(subject) and
     not [subject.point1, subject.point2].any?{|p| subject.contains_point?(p)} and
     not [subject.point1, subject.point2].any?{|p| subject.contains_point?(p)}).should be_false

    (subject.intersects_with?(segment) and
     not [subject.point1, subject.point2].any?{|p| segment.contains_point?(p)} and
     not [segment.point1, segment.point2].any?{|p| subject.contains_point?(p)}).should be_false

    (subject.intersects_with?(segment2) and
     not [subject.point1, subject.point2].any?{|p| segment2.contains_point?(p)} and
     not [segment2.point1, segment2.point2].any?{|p| subject.contains_point?(p)}).should be_true
  end
end

describe Geometry::Polygon do
  subject do
    Polygon [
      Point(0.0, 0.0),
      Point(1.0, 0.0),
      Point(1.0, 1.0),
      Point(0.0, 1.0),
    ]
  end
  it 'works' do
    subject
  end

  context '#inside?' do
    it 'works' do
      subject.should be_inside(Point(0.5, 0.5))
      subject.should be_inside(Point(0.9, 0.9))
      subject.should be_inside(Point(0.1, 0.9))
      subject.should be_inside(Point(0.9, 0.1))

      subject.should_not be_inside(Point(0.0, 0.0))
      subject.should_not be_inside(Point(1.0, 1.0))
      subject.should_not be_inside(Point(0.5, 0.0))
      subject.should_not be_inside(Point(1.1, 0.5))
    end
  end

  context '#intersects_with?' do
    it 'works' do
      subject.should be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(0.5,0.5)))
      subject.should be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(2.0,2.0)))

      subject.should be_intersects_with(
        Segment(Point(0.3,0.3),Point(0.7,0.7)))

      subject.should_not be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(-1.0,2.0)))

      subject.should_not be_intersects_with(
        Segment(Point(0.0,0.0),Point(1.0,0.0)))

      subject.should_not be_intersects_with(
        Segment(Point(1.0,-1.0),Point(-1.0,1.0)))
    end
  end

  context '#counting?' do
    it 'works with points' do
      subject.should be_counting(Point(0.5, 0.5))
      subject.should be_counting(Point(0.9, 0.9))
      subject.should be_counting(Point(0.1, 0.9))
      subject.should be_counting(Point(0.9, 0.1))

      subject.should_not be_counting(Point(0.0, 0.0))
      subject.should_not be_counting(Point(1.0, 1.0))
      subject.should_not be_counting(Point(1.1, 0.5))
    end

    it 'works with segments' do
      subject.should be_counting(
        Segment(Point(-1.0,-1.0),Point(0.5,0.5)))
      subject.should be_counting(
        Segment(Point(-1.0,-1.0),Point(2.0,2.0)))

      subject.should_not be_counting(
        Segment(Point(-1.0,-1.0),Point(-1.0,2.0)))

      subject.should_not be_counting(
        Segment(Point(0.0,0.0),Point(1.0,0.0)))
    end

    it 'will work with segments' do
      subject.should be_counting(
        Segment(Point(0.3,0.3),Point(0.7,0.7)))

      subject.should_not be_intersects_with(
        Segment(Point(1.0,-1.0),Point(-1.0,1.0)))
    end

    it 'works with cells' do
      subject.should be_counting(
        Polygon [
          Point(0.5, 0.5),
          Point(1.5, 0.5),
          Point(1.5, 1.5),
          Point(0.5, 1.5),
      ])

      subject.should be_counting(
        Polygon [
          Point(0.3, 0.3),
          Point(0.7, 0.3),
          Point(0.7, 0.7),
          Point(0.3, 0.7),
      ])

      subject.should be_counting(
        Polygon [
          Point(-0.5, -0.5),
          Point(1.5, -0.5),
          Point(1.5, 1.5),
          Point(-0.5, 1.5),
      ])

      subject.should_not be_counting(
        Polygon [
          Point(1.0, 0.0),
          Point(2.0, 0.0),
          Point(2.0, 1.0),
          Point(1.0, 1.0),
      ])

      subject.should_not be_counting(
        Polygon [
          Point(1.0, 1.0),
          Point(2.0, 1.0),
          Point(2.0, 2.0),
          Point(1.0, 2.0),
      ])
    end
  end
end
