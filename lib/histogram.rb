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
      step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qminy}.min
    lminy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qminx}.min
    lmaxx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qmaxy}.max
    lmaxy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qmaxx}.max

    uminx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qminy}.max
    uminy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qminx}.max
    umaxx = (miny..maxy).
      step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qmaxy}.min
    umaxy = (minx..maxx).
      step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qmaxx}.min

    return [
      [lminx, lminy, lmaxx, lmaxy].map{|v|v[1]},
      [uminx, uminy, umaxx, umaxy].map{|v|v[1]},
      [lminx, lminy, lmaxx, lmaxy].map{|v|v[0]},
      [uminx, uminy, umaxx, umaxy].map{|v|v[0]},
    ]
  end

  def exact_query minx, miny, maxx, maxy
    data[minx*2..(maxx-1)*2].
      map{|line|line[miny*2..(maxy-1)*2].inject(:+)}.inject(:+)
  end

  def area minx_, miny_, maxx_, maxy_
    (maxx_ - minx_) * (maxy_ - miny_)
  end

  def query qminx, qminy, qmaxx, qmaxy
    lbound, ubound = bounds(qminx, qminy, qmaxx, qmaxy)
  end
end
