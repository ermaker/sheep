require 'sheep'
require 'algorithms/histogram'

module Algorithms
  class Simple
    attr_accessor :histograms

    def initialize sheep, *args
      group_number, stepx, stepy = case args.size
                                   when 1
                                     memory_size = args[0]
                                     numberof_variables = memory_size / 4
                                     good_group_size = (
                                       (numberof_variables-1) ** (1.0/3)
                                     ).floor

                                     numberof_variables =
                                       (numberof_variables-1)/good_group_size
                                     good_size = (- 0.5 + Math.sqrt(numberof_variables-6)/2.0).floor
                                     [good_group_size, good_size, good_size]
                                   when 3
                                     args
                                   end
      @histograms = group_number.times.map do |idx|
        s = Sheep.new
        s.objects = sheep.objects.
          select.with_index {|obj,i| i % group_number == idx}
        Algorithms::Histogram.new s, stepx, stepy
      end
    end

    def data_size
      @histograms.map(&:data_size).inject(:+)
    end

    def data io=$stderr
      pbar = ProgressBar.new('Compute data', data_size, io)
      result = _data pbar
      pbar.finish
      result
    end

    def _data pbar
      @histograms.map do |histogram|
        histogram._data pbar
      end
    end

    def query minx, miny, maxx, maxy
      @histograms.map do |histogram|
        histogram.query(minx, miny, maxx, maxy)
      end.inject(0.0, :+)
    end

    def capture filename
      scale = 10000
      margin = 200

      points = @histograms.map(&:sheep).map(&:objects).flatten(2)
      minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
      size = minmax.map{|v| v[1]}

      canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
      pbar = ProgressBar.new('Draw objects', @histograms.map(&:capture_size).inject(0,:+))
      gc = Magick::Draw.new
      _capture gc, scale, pbar
      pbar.finish
      gc.draw(canvas)
      canvas.flip!
      canvas.write(filename)
    end

    def _capture gc, scale, pbar
      @histograms.each do |histogram|
        histogram._capture gc, scale, pbar
      end
    end
  end
end
