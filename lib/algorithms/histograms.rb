require 'progressbar'

module Algorithms
  module Histograms
    attr_accessor :histograms

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
