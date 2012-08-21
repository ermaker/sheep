class Histogram
  attr_accessor :data, :minx, :miny, :maxx, :maxy, :stepx, :stepy

  def initialize data, minx, miny, maxx, maxy, stepx, stepy
    @data = data
    @minx = minx
    @miny = miny
    @maxx = maxx
    @maxy = maxy
    @stepx = stepx
    @stepy = stepy
  end

  def bounds qminx, qminy, qmaxx, qmaxy
    lminx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qminy}.min[1]
    lminy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qminx}.min[1]
    lmaxx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qmaxy}.max[1]
    lmaxy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qmaxx}.max[1]

    uminx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qminy}.max[1]
    uminy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qminx}.max[1]
    umaxx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qmaxy}.min[1]
    umaxy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qmaxx}.min[1]

    return [[lminx, lminy, lmaxx, lmaxy], [uminx, uminy, umaxx, umaxy]]
  end
end
