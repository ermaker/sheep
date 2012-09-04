require 'sheep'
require 'algorithms/histogram'

module Algorithms
  class Simple
    attr_accessor :histograms

    def initialize sheep, group_number, stepx, stepy
      @histograms = group_number.times.map do |idx|
        s = Sheep.new
        s.objects = sheep.objects.
          select.with_index {|obj,i| i % group_number == idx}
        Algorithms::Histogram.new s, stepx, stepy
      end
    end

    def data
      @histograms.map do |histogram|
        histogram.data
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
