require 'RMagick'
require 'progressbar'
require 'geometry'
require 'ext/geometry'

class Sheep
  class INVALID_FORMAT < Exception; end

  def convert source, destination, io=STDERR
    File.open(source, 'rt') do |input|
      File.open(destination, 'w') do |output|
        raise INVALID_FORMAT unless input.readline =~ /^dimension=2$/
        raise INVALID_FORMAT unless input.readline =~ /^numPolygons=(\d+)$/
        output.puts $1.to_i
        begin
          pbar = ProgressBar.new('Convert objects', $1.to_i, io)
          loop do
            raise INVALID_FORMAT unless input.readline =~ /^numVertices=(\d+)$/
            output.print "#{$1.to_i-1} "
            output.puts((1..$1.to_i).map do |idx|
              input.readline.split.map(&:to_f)
            end[0..-2].flatten.join(' '))
            pbar.inc
          end
          pbar.finish
        rescue EOFError
        end
      end
    end
  end

  class NUMBEROF_OBJECTS_NOT_MATCHED < Exception; end
  class NUMBEROF_POINTS_NOT_MATCHED < Exception; end

  attr_reader :objects

  def load filename
    open(filename) do |file|
      numberof_objects = file.readline.to_i
      @objects = file.each_line.map do |line|
        numberof_points, *points = line.split
        numberof_points = numberof_points.to_i
        points = points.map(&:to_f).each_slice(2).to_a
        raise NUMBEROF_POINTS_NOT_MATCHED unless
          numberof_points == points.size
        points
      end
      raise NUMBEROF_OBJECTS_NOT_MATCHED unless
        numberof_objects == @objects.size
    end
  end

  def capture filename
    scale = 10000
    margin = 200

    points = @objects.flatten(1)
    minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
    size = minmax.map{|v| v[1]}

    canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
    gc = Magick::Draw.new
    gc.stroke('#001aff')
    gc.stroke_width(scale/5000)
    gc.fill('transparent')

    pbar = ProgressBar.new('Draw objects', @objects.size)
    @objects.each do |object|
      gc.polygon(*object.flatten.map{|v|v*scale})
      pbar.inc
    end
    pbar.finish

    gc.draw(canvas)
    canvas.write(filename)
  end

  def euler_histogram_step objs, minx, miny, maxx, maxy, stepx, stepy,
    idxx, idxy
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

  def euler_histogram objs, minx, miny, maxx, maxy, stepx, stepy
    (0..stepx*2-2).map do |idxx|
      (0..stepy*2-2).map do |idxy|
        euler_histogram_step(objs,minx,miny,maxx,maxy,stepx,stepy,idxx,idxy)
      end
    end
  end
end
