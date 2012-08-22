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

    def query minx, miny, maxx, maxy
      @histograms.map do |histogram|
        histogram.query(minx, miny, maxx, maxy)
      end.inject(0.0, :+)
    end
  end
end
