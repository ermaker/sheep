require 'progressbar'

module Algorithms
  class Histogram
    attr_accessor :sheep, :data, :minx, :miny, :maxx, :maxy, :stepx, :stepy

    def data_size
      (stepx*2-1) * (stepy*2-1)
    end

    def data io=$stderr
      pbar = ProgressBar.new('Compute data', data_size, io)
      result = _data pbar
      pbar.finish
      result
    end

    def _data pbar
      @data ||= euler_histogram(pbar)
    end

    def initialize sheep, *args
      stepx, stepy = case args.size
                     when 1
                       memory_size = args[0]
                       numberof_variables = memory_size / 4
                       good_size = (- 0.5 +
                                    Math.sqrt(numberof_variables-6)/2.0).floor
                       [good_size, good_size]
                     when 2
                       args
                     else
                     end
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
      (@data[minx*2..(maxx-1)*2]||[]).
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

    def euler_histogram_step idxx, idxy
      objs = @sheep.objects
      if idxx.odd? and idxy.odd?
        return objs.count do |obj|
          Polygon(obj.map{|p|Geometry::Point.new_by_array(p)}).counting?(
            Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                  miny + ((idxx+1)/2)*(maxy-miny)/stepx))
        end
      end

      if idxx.even? and idxy.even?
        return objs.count do |obj|
          Polygon(obj.map{|p|Geometry::Point.new_by_array(p)}).counting?(
            Polygon [
            Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                  miny + ((idxx+1)/2)*(maxy-miny)/stepx),
            Point(minx + ((idxy+1)/2+1)*(maxx-minx)/stepy,
                  miny + ((idxx+1)/2)*(maxy-miny)/stepx),
            Point(minx + ((idxy+1)/2+1)*(maxx-minx)/stepy,
                  miny + ((idxx+1)/2+1)*(maxy-miny)/stepx),
            Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                  miny + ((idxx+1)/2+1)*(maxy-miny)/stepx),
          ])
        end
      end

      if idxx.even? and idxy.odd?
        return -objs.count do |obj|
          Polygon(obj.map{|p|Geometry::Point.new_by_array(p)}).counting?(
            Segment(
              Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                    miny + ((idxx+1)/2)*(maxy-miny)/stepx),
              Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                    miny + ((idxx+1)/2+1)*(maxy-miny)/stepx)
          ))
        end
      end

      if idxx.odd? and idxy.even?
        return -objs.count do |obj|
          Polygon(obj.map{|p|Geometry::Point.new_by_array(p)}).counting?(
            Segment(
              Point(minx + ((idxy+1)/2)*(maxx-minx)/stepy,
                    miny + ((idxx+1)/2)*(maxy-miny)/stepx),
              Point(minx + ((idxy+1)/2+1)*(maxx-minx)/stepy,
                    miny + ((idxx+1)/2)*(maxy-miny)/stepx)
          ))
        end
      end
    end

    def euler_histogram pbar
      (0..stepx*2-2).map do |idxx|
        (0..stepy*2-2).map do |idxy|
          pbar.inc
          euler_histogram_step(idxx,idxy)
        end
      end
    end

    def get_uidx object
      mbr = object.transpose.map(&:minmax).transpose.flatten
      _, uidx, _, _ = bounds(*mbr)
      return uidx
    end

    def step0 uidx
      Array.new((uidx[3]-1 - uidx[1])*2 + 1) {Array.new((uidx[2]-1 - uidx[0])*2 + 1) {0}}
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
