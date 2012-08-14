require 'geometry'
require 'ext/geometry'

describe Geometry::Point do
  it 'works' do
    point = Point(1.0, 2.0)
    point.x.should == 1.0
    point.y.should == 2.0
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

  context '#contains?' do
    it 'works' do
      subject.should be_contain(Point(0.5, 0.5))
      subject.should be_contain(Point(0.0, 0.0))
      subject.should be_contain(Point(1.0, 1.0))

      subject.should_not be_contain(Point(1.1, 0.5))
    end
  end

  context '#intersects_with?' do
    it 'works' do
      subject.should be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(0.5,0.5)))
      subject.should be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(2.0,2.0)))


      subject.should_not be_intersects_with(
        Segment(Point(-1.0,-1.0),Point(-1.0,2.0)))

      pending
      subject.should_not be_intersects_with(
        Segment(Point(1.0,-1.0),Point(-1.0,1.0)))
    end
  end
end
