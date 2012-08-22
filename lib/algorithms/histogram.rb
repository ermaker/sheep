module Algorithms
  class Histogram
    attr_accessor :data, :minx, :miny, :maxx, :maxy, :stepx, :stepy

    def initialize sheep, stepx, stepy
      @data = sheep.euler_histogram(
        sheep.objects, sheep.minx, sheep.miny, sheep.maxx, sheep.maxy, stepx, stepy)
      @minx = sheep.minx
      @miny = sheep.miny
      @maxx = sheep.maxx
      @maxy = sheep.maxy
      @stepx = stepx
      @stepy = stepy
    end

    def bounds qminx, qminy, qmaxx, qmaxy
      lminx = (miny..maxy).
        step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qminy}.min
      lminx = [maxy, stepx] unless lminx
      lminy = (minx..maxx).
        step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qminx}.min
      lminy = [maxx, stepy] unless lminy
      lmaxx = (miny..maxy).
        step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qmaxy}.max
      lmaxx = [miny, 0] unless lmaxx
      lmaxy = (minx..maxx).
        step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qmaxx}.max
      lmaxy = [minx, 0] unless lmaxy

      uminx = (miny..maxy).
        step((maxy-miny)/stepx).map.with_index.select {|y,| y<=qminy}.max
      uminx = [miny, 0] unless uminx
      uminy = (minx..maxx).
        step((maxx-minx)/stepy).map.with_index.select {|x,| x<=qminx}.max
      uminy = [minx, 0] unless uminy
      umaxx = (miny..maxy).
        step((maxy-miny)/stepx).map.with_index.select {|y,| y>=qmaxy}.min
      umaxx = [maxy, stepx] unless umaxx
      umaxy = (minx..maxx).
        step((maxx-minx)/stepy).map.with_index.select {|x,| x>=qmaxx}.min
      umaxy = [maxx, stepy] unless umaxy

      return [
        [lminx, lminy, lmaxx, lmaxy].map{|v|v[1]},
        [uminx, uminy, umaxx, umaxy].map{|v|v[1]},
        [lminx, lminy, lmaxx, lmaxy].map{|v|v[0]},
        [uminx, uminy, umaxx, umaxy].map{|v|v[0]},
      ]
    end

    def exact_query minx, miny, maxx, maxy
      (data[minx*2..(maxx-1)*2]||[]).
        map{|line|(line[miny*2..(maxy-1)*2]||[]).inject(0,:+)}.inject(0,:+)
    end

    def area minx_, miny_, maxx_, maxy_
      return 0.0 if maxx_ < minx_
      return 0.0 if maxy_ < miny_
      (maxx_ - minx_) * (maxy_ - miny_)
    end

    def query qminx, qminy, qmaxx, qmaxy
      lidx, uidx, lbound, ubound = bounds(qminx, qminy, qmaxx, qmaxy)
      lower = exact_query(*lidx)
      upper = exact_query(*uidx)
      l_a = area(*lbound)
      u_a = area(*ubound)
      q_a = area(qminx, qminy, qmaxx, qmaxy)
      return exact_query(*uidx) if lidx == uidx
      return 0.0 if u_a == 0.0 and l_a == 0.0
      raise if u_a == l_a
      return (q_a-l_a)/(u_a-l_a)*(upper-lower) + lower
    end
  end
end
