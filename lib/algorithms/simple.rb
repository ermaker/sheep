require 'sheep'
require 'algorithms/histograms'
require 'algorithms/histogram'

module Algorithms
  class Simple
    include Histograms

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
  end
end
