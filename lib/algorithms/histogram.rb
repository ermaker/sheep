module Algorithms
  class Histogram
    attr_accessor :sheep, :data, :minx, :miny, :maxx, :maxy, :stepx, :stepy

    def data
      @data ||= @sheep.euler_histogram(
        sheep.objects, sheep.minx, sheep.miny, sheep.maxx, sheep.maxy, stepx, stepy)
    end

    def initialize sheep, stepx, stepy
      @sheep = sheep
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
      return 0.0 if sheep.objects.empty?
      qminx = minx if qminx < minx
      qminy = miny if qminy < miny
      qmaxx = maxx if qmaxx > maxx
      qmaxy = maxy if qmaxy > maxy
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

    def capture_size
      (stepx+1) * (stepy+1)
    end

    def capture filename
      scale = 10000
      margin = 200

      points = sheep.objects.flatten(1)
      minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
      size = minmax.map{|v| v[1]}

      canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
      pbar = ProgressBar.new('Draw objects', sheep.capture_size + capture_size)
      gc = Magick::Draw.new
      _capture gc, scale, pbar
      pbar.finish
      gc.draw(canvas)
      canvas.flip!
      canvas.write(filename)
    end

    def _capture gc, scale, pbar
      sheep._capture gc, scale, pbar
      gc.stroke('#001aff')
      gc.stroke_width(scale/10000)

      (minx..maxx).step((maxx-minx)/stepy).each do |x|
        gc.line(x*scale, miny*scale, x*scale, maxy*scale)
        pbar.inc
      end

      (miny..maxy).step((maxy-miny)/stepx).each do |y|
        gc.line(minx*scale, y*scale, maxx*scale, y*scale)
        pbar.inc
      end
    end
  end
end
