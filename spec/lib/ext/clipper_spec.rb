require 'clipper'

describe Clipper do
  it 'works' do
    clipper = Clipper::Clipper.new
    clipper.add_subject_polygon(
      [
        [0.5, 0.5], [1.5, 0.5], [1.5, 1.5], [0.5, 1.5]
    ])
    clipper.add_clip_polygon(
      [
        [0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]
    ])
    clipper.intersection.should_not be_empty

    clipper = Clipper::Clipper.new
    clipper.add_subject_polygon(
      [
        [1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0]
    ])
    clipper.add_clip_polygon(
      [
        [0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]
    ])
    clipper.intersection.should be_empty

    clipper = Clipper::Clipper.new
    clipper.add_subject_polygon(
      [
        [1.0, 0.0], [2.0, 0.0], [2.0, 1.0], [1.0, 1.0]
    ])
    clipper.add_clip_polygon(
      [
        [0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]
    ])
    clipper.intersection.should be_empty
  end
end
