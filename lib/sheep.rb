require 'RMagick'

class Sheep
  class INVALID_FORMAT < Exception; end

  def convert source, destination
    File.open(source, 'rt') do |input|
      File.open(destination, 'w') do |output|
        raise INVALID_FORMAT unless input.readline =~ /^dimension=2$/
        raise INVALID_FORMAT unless input.readline =~ /^numPolygons=(\d+)$/
        output.puts $1.to_i
        begin
          loop do
            raise INVALID_FORMAT unless input.readline =~ /^numVertices=(\d+)$/
            output.print "#{$1.to_i-1} "
            output.puts((1..$1.to_i).map do |idx|
              input.readline.split.map(&:to_f)
            end[0..-2].flatten.join(' '))
          end
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
    scale = 5000
    margin = 2000

    points = @objects.flatten(1)
    minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
    size = minmax.map{|v| v[1]}

    canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
    gc = Magick::Draw.new
    gc.stroke('#001aff')
    gc.stroke_width(scale/50)
    gc.fill('transparent')

    @objects.each do |object|
      gc.polygon(*object.flatten.map{|v|v*scale})
    end

    gc.draw(canvas)
    canvas.write(filename)
  end
end
