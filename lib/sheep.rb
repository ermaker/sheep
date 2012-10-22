require 'RMagick'
require 'progressbar'
require 'geometry'
require 'ext/geometry'

class Sheep
  class NUMBEROF_OBJECTS_NOT_MATCHED < Exception; end
  class NUMBEROF_POINTS_NOT_MATCHED < Exception; end

  attr_accessor :minx, :miny, :maxx, :maxy

  attr_reader :objects
  def objects= value
    @objects = value
    points = @objects.flatten(1)
    @minx = points.map{|v|v[0]}.min
    @miny = points.map{|v|v[1]}.min
    @maxx = points.map{|v|v[0]}.max
    @maxy = points.map{|v|v[1]}.max
  end

  def load filename
    open(filename) do |file|
      numberof_objects = file.readline.to_i
      self.objects = file.each_line.map do |line|
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

  def capture_size
    @objects.size
  end

  def capture filename
    scale = 10000
    margin = 200

    points = @objects.flatten(1)
    minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
    size = minmax.map{|v| v[1]}

    canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
    pbar = ProgressBar.new('Draw objects', capture_size)
    gc = Magick::Draw.new
    _capture gc, scale, pbar
    pbar.finish
    gc.draw(canvas)
    canvas.flip!
    canvas.write(filename)
  end

  def _capture gc, scale, pbar
    gc.stroke('#000000')
    gc.stroke_width(scale/5000)
    gc.fill('transparent')

    @objects.each do |object|
      gc.polygon(*object.flatten.map{|v|v*scale})
      pbar.inc
    end
  end
end
