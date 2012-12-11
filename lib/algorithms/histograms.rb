require 'progressbar'
require 'capturable'

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

    include Capturable

    def capture_points
      @histograms.map(&:capture_points).flatten(1)
    end

    def capture_size
      @histograms.map(&:capture_size).inject(0,:+)
    end

    def _capture gc, scale, pbar
      @histograms.each do |histogram|
        histogram._capture gc, scale, pbar
      end
    end
  end
end
