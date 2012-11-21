require 'yaml'
require 'capturable'

class Query
  class << self
    def generate sheep, area
      width = nil
      height = nil
      begin
        width = (sheep.maxx-sheep.minx)*rand
        height = (sheep.maxx-sheep.minx)*(sheep.maxy-sheep.miny) * area / width
      end while height > sheep.maxy-sheep.miny

      x = sheep.minx + (sheep.maxx-sheep.minx-width) * rand
      y = sheep.miny + (sheep.maxy-sheep.miny-height) * rand
      [x, y, x+width, y+height]
    end

    def save filename, queries
      File.open(filename, 'w') do |f|
        queries.each do |query|
          f.puts query.join(' ')
        end
      end
    end

    def load filename
      File.open(filename) do |f|
        f.rewind
        f.each_line.map do |line|
          yield line.split(' ').map(&:to_f)
        end
      end
    end

    def size filename
      File.open(filename) do |f|
        f.rewind
        f.each_line.inject(0) {|c,l| c+1}
      end
    end
  end

  def initialize query, capturable
    @query = query
    @capturable = capturable
  end

  include Capturable

  def capture_points
    @capturable.capture_points
  end

  def capture_size
    @capturable.capture_size + 4
  end

  def _capture gc, scale, pbar
    @capturable._capture gc, scale, pbar

    minx, miny, maxx, maxy = @query
    gc.stroke('#ff0000')
    gc.stroke_width(2)
    gc.line(minx*scale, miny*scale, minx*scale, maxy*scale)
    pbar.inc
    gc.line(maxx*scale, miny*scale, maxx*scale, maxy*scale)
    pbar.inc
    gc.line(minx*scale, miny*scale, maxx*scale, miny*scale)
    pbar.inc
    gc.line(minx*scale, maxy*scale, maxx*scale, maxy*scale)
    pbar.inc
  end
end
