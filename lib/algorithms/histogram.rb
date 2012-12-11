require 'log_config'
require 'progressbar'
require 'capturable'

module Algorithms
  class Histogram
    attr_accessor :sheep, :data, :minx, :miny, :maxx, :maxy, :stepx, :stepy

    def data_size
      sheep.objects.size
    end

    def data io=$stderr
      pbar = ProgressBar.new('Compute data', data_size, io)
      result = _data pbar
      pbar.finish
      result
    end

    def _data pbar
      #@data ||= euler_histogram(pbar)
      @data ||= histogram(pbar)
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

      lidxx = ((qminy-miny)/(maxy-miny)*stepx).ceil
      lidxx = stepx if lidxx > stepx
      lidxx = 0 if lidxx < 0
      lminx = [miny+lidxx*(maxy-miny)/stepx, lidxx]
      lidxy = ((qminx-minx)/(maxx-minx)*stepy).ceil
      lidxy = stepy if lidxy > stepy
      lidxy = 0 if lidxy < 0
      lminy = [minx+lidxy*(maxx-minx)/stepy, lidxy]
      lidxx = ((qmaxy-miny)/(maxy-miny)*stepx).floor
      lidxx = stepx if lidxx > stepx
      lidxx = 0 if lidxx < 0
      lmaxx = [miny+lidxx*(maxy-miny)/stepx, lidxx]
      lidxy = ((qmaxx-minx)/(maxx-minx)*stepy).floor
      lidxy = stepy if lidxy > stepy
      lidxy = 0 if lidxy < 0
      lmaxy = [minx+lidxy*(maxx-minx)/stepy, lidxy]

      uidxx = ((qminy-miny)/(maxy-miny)*stepx).floor
      uidxx = stepx if uidxx > stepx
      uidxx = 0 if uidxx < 0
      uminx = [miny+uidxx*(maxy-miny)/stepx, uidxx]
      uidxy = ((qminx-minx)/(maxx-minx)*stepy).floor
      uidxy = stepy if uidxy > stepy
      uidxy = 0 if uidxy < 0
      uminy = [minx+uidxy*(maxx-minx)/stepy, uidxy]
      uidxx = ((qmaxy-miny)/(maxy-miny)*stepx).ceil
      uidxx = stepx if uidxx > stepx
      uidxx = 0 if uidxx < 0
      umaxx = [miny+uidxx*(maxy-miny)/stepx, uidxx]
      uidxy = ((qmaxx-minx)/(maxx-minx)*stepy).ceil
      uidxy = stepy if uidxy > stepy
      uidxy = 0 if uidxy < 0
      umaxy = [minx+uidxy*(maxx-minx)/stepy, uidxy]

      return [
        [lminx, lminy, lmaxx, lmaxy].map{|v|v[1]},
        [uminx, uminy, umaxx, umaxy].map{|v|v[1]},
        [lminx, lminy, lmaxx, lmaxy].map{|v|v[0]},
        [uminx, uminy, umaxx, umaxy].map{|v|v[0]},
      ]
    end

    def exact_query minx, miny, maxx, maxy
      return 0 if maxx <= 0 or maxy <= 0
      return 0 if minx >= maxx or miny >= maxy
      result = @data[(maxx-1)*2][(maxy-1)*2]
      result -= @data[minx*2-1][(maxy-1)*2] if minx > 0
      result -= @data[(maxx-1)*2][miny*2-1] if miny > 0
      result += @data[minx*2-1][miny*2-1] if minx > 0 and miny > 0
      return result
    end

    def area minx_, miny_, maxx_, maxy_
      return 0.0 if maxx_ < minx_
      return 0.0 if maxy_ < miny_
      (maxx_ - minx_) * (maxy_ - miny_)
    end

    def query qminx, qminy, qmaxx, qmaxy
      return 0.0 unless @minx and @miny and @maxx and @maxy
      qminx = @minx if qminx < @minx
      qminy = @miny if qminy < @miny
      qmaxx = @maxx if qmaxx > @maxx
      qmaxy = @maxy if qmaxy > @maxy
      lidx, uidx, lbound, ubound = bounds(qminx, qminy, qmaxx, qmaxy)
      $logger.debug('Algorithms::Histogram#query') { 'lidx: %s, uidx: %s' %
        [lidx.to_s, uidx.to_s] }
      lower = exact_query(*lidx)
      upper = exact_query(*uidx)
      $logger.debug('Algorithms::Histogram#query') do
        'lower: %s, upper: %s' % [lower.to_s, upper.to_s]
      end
      l_a = area(*lbound)
      u_a = area(*ubound)
      q_a = area(qminx, qminy, qmaxx, qmaxy)
      $logger.debug('Algorithms::Histogram#query') do
        'l_a: %s, u_a: %s, q_a: %s' % [l_a.to_s, u_a.to_s, q_a.to_s]
      end
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

    def get_polygon object
      Polygon(object.uniq.map{|p|Geometry::Point.new_by_array(p)})
    end

    def get_uidx object
      mbr = object.transpose.map(&:minmax).transpose.flatten
      _, uidx, _, _ = bounds(*mbr)
      return uidx
    end

    def get_result
      Array.new(stepx*2 - 1) {Array.new(stepy*2 - 1) {0}}
    end

    def step0 uidx
      Array.new((uidx[2]-1 - uidx[0])*2 + 1) {Array.new((uidx[3]-1 - uidx[1])*2 + 1) {0}}
    end

    def step1 step0, uidx, polygon
      (uidx[2]-uidx[0]-1).times do |idxx|
        (uidx[3]-uidx[1]-1).times do |idxy|
          $logger.debug('Algorithms::Histogram#step1') do
            'idxx: %d, idxy: %d' % [idxx, idxy]
          end
          $logger.debug('Algorithms::Histogram#step1') do
            'point x: %f, y: %f' % [
              minx + (uidx[1] + idxy+1)*(maxx-minx)/stepy,
              miny + (uidx[0] + idxx+1)*(maxy-miny)/stepx]
          end
          if polygon.counting?(
            Point(minx + (uidx[1] + idxy+1)*(maxx-minx)/stepy,
                  miny + (uidx[0] + idxx+1)*(maxy-miny)/stepx))
            $logger.debug('Algorithms::Histogram#step1') {'inside of the if statement'}
            step0[idxx*2+1][idxy*2+1] = 1

            step0[idxx*2][idxy*2+1] = -1
            step0[idxx*2+1][idxy*2] = -1
            step0[idxx*2+1][idxy*2+2] = -1
            step0[idxx*2+2][idxy*2+1] = -1

            step0[idxx*2][idxy*2] = 1
            step0[idxx*2][idxy*2+2] = 1
            step0[idxx*2+2][idxy*2] = 1
            step0[idxx*2+2][idxy*2+2] = 1
          end
        end
      end
      step0
    end

    def step2 step1, uidx, polygon
      (uidx[2]-uidx[0]).times do |idxx|
        (uidx[3]-uidx[1]-1).times do |idxy|
          next unless step1[idxx*2][idxy*2+1] == 0
          if polygon.counting?(
            Segment(
              Point(minx + (uidx[1]+idxy+1)*(maxx-minx)/stepy,
                    miny + (uidx[0]+idxx)*(maxy-miny)/stepx),
              Point(minx + (uidx[1]+idxy+1)*(maxx-minx)/stepy,
                    miny + (uidx[0]+idxx+1)*(maxy-miny)/stepx)
          ))
            step1[idxx*2][idxy*2+1] = -1

            step1[idxx*2][idxy*2] = 1
            step1[idxx*2][idxy*2+2] = 1
          end
        end
      end
      step1
    end

    def step3 step2, uidx, polygon
      (uidx[2]-uidx[0]-1).times do |idxx|
        (uidx[3]-uidx[1]).times do |idxy|
          next unless step2[idxx*2+1][idxy*2] == 0
          if polygon.counting?(
            Segment(
              Point(minx + (uidx[1]+idxy)*(maxx-minx)/stepy,
                    miny + (uidx[0]+idxx+1)*(maxy-miny)/stepx),
              Point(minx + (uidx[1]+idxy+1)*(maxx-minx)/stepy,
                    miny + (uidx[0]+idxx+1)*(maxy-miny)/stepx)
          ))
            step2[idxx*2+1][idxy*2] = -1

            step2[idxx*2][idxy*2] = 1
            step2[idxx*2+2][idxy*2] = 1
          end
        end
      end
      step2
    end

    def step4 step3, uidx, polygon
      (uidx[2]-uidx[0]).times do |idxx|
        (uidx[3]-uidx[1]).times do |idxy|
          next unless step3[idxx*2][idxy*2] == 0
          if polygon.counting?(
            Polygon [
            Point(minx + (uidx[1]+idxy)*(maxx-minx)/stepy,
                  miny + (uidx[0]+idxx)*(maxy-miny)/stepx),
            Point(minx + (uidx[1]+idxy+1)*(maxx-minx)/stepy,
                  miny + (uidx[0]+idxx)*(maxy-miny)/stepx),
            Point(minx + (uidx[1]+idxy+1)*(maxx-minx)/stepy,
                  miny + (uidx[0]+idxx+1)*(maxy-miny)/stepx),
            Point(minx + (uidx[1]+idxy)*(maxx-minx)/stepy,
                  miny + (uidx[0]+idxx+1)*(maxy-miny)/stepx),
          ])
            step3[idxx*2][idxy*2] = 1
          end
        end
      end
      step3
    end

    def step5 result, step4, uidx
      $logger.debug('Algorithms::Histogram#step5') do
        'result size: %d, %d' % [result.size, result[0].size]
      end
      $logger.debug('Algorithms::Histogram#step5') do
        'uidx: %s' % uidx.to_s
      end
      $logger.debug('Algorithms::Histogram#step5') do
        'step4 size: %d, %d' % [step4.size, step4[0].size]
      end
      ((uidx[2]-uidx[0])*2-1).times do |idxx|
        ((uidx[3]-uidx[1])*2-1).times do |idxy|
          $logger.debug('Algorithms::Histogram#step5') do
            'idxx: %d, idxy: %d' % [idxx, idxy]
          end
          $logger.debug('Algorithms::Histogram#step5') do
            'result: %s' % result[uidx[0]*2 + idxx][uidx[1]*2 + idxy]
          end
          $logger.debug('Algorithms::Histogram#step5') do
            'step4: %s' % step4[idxx][idxy]
          end
          result[uidx[0]*2 + idxx][uidx[1]*2 + idxy] += step4[idxx][idxy]
        end
      end
      result
    end

    def _sum result
      result.map! do |line|
        s = 0
        line.map!{|v| s+=v}
      end
    end

    def sum result
      result.replace(_sum(_sum(result).transpose).transpose)
    end

    def histogram pbar
      $logger.debug('Algorithms::Histogram#histogram') {'start'}
      $logger.debug('Algorithms::Histogram#histogram') {'get_result'}
      result = get_result
      $logger.debug('Algorithms::Histogram#histogram') {'each object'}
      sheep.objects.each do |object|
        $logger.debug('Algorithms::Histogram#histogram') do
          'with object %s' % object.to_s
        end
        $logger.debug('Algorithms::Histogram#histogram') {'polygon'}
        polygon = get_polygon object
        $logger.debug('Algorithms::Histogram#histogram') {'uidx'}
        uidx = get_uidx object
        $logger.debug('Algorithms::Histogram#histogram') do
          'uidx: %s' % uidx.to_s
        end

        if uidx[0] != uidx[2] and uidx[1] != uidx[3]
          $logger.debug('Algorithms::Histogram#histogram') {'step0'}
          local = step0 uidx
          $logger.debug('Algorithms::Histogram#histogram') do
            'local: %s' % local.to_s
          end

          $logger.debug('Algorithms::Histogram#histogram') {'step1'}
          step1 local, uidx, polygon
          $logger.debug('Algorithms::Histogram#histogram') {'step2'}
          step2 local, uidx, polygon
          $logger.debug('Algorithms::Histogram#histogram') {'step3'}
          step3 local, uidx, polygon
          $logger.debug('Algorithms::Histogram#histogram') {'step4'}
          step4 local, uidx, polygon
          $logger.debug('Algorithms::Histogram#histogram') {'step5'}
          step5 result, local, uidx
        end

        pbar.inc
      end

      $logger.debug('Algorithms::Histogram#histogram') {'sum'}
      sum result

      $logger.debug('Algorithms::Histogram#histogram') {'end'}
      result
    end

    include Capturable

    def capture_points
      return [] unless sheep
      return sheep.objects.flatten(1)
    end

    def capture_size
      result = (stepx+1) * (stepy+1)
      result += sheep.capture_size if sheep
      return result
    end

    def _capture gc, scale, pbar
      sheep._capture gc, scale, pbar if sheep
      gc.stroke('#001aff')
      gc.stroke_width(3)

      (minx..maxx).step((maxx-minx)/stepy).each do |x|
        gc.line(x*scale, miny*scale, x*scale, maxy*scale)
        pbar.inc
      end

      (miny..maxy).step((maxy-miny)/stepx).each do |y|
        gc.line(minx*scale, y*scale, maxx*scale, y*scale)
        pbar.inc
      end

      gc.stroke('#001aff')
      gc.stroke_width(6)
      gc.line(minx*scale, miny*scale, minx*scale, maxy*scale)
      gc.line(maxx*scale, miny*scale, maxx*scale, maxy*scale)
      gc.line(minx*scale, miny*scale, maxx*scale, miny*scale)
      gc.line(minx*scale, maxy*scale, maxx*scale, maxy*scale)
    end
  end
end
