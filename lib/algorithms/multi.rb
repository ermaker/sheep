require 'log_config'
require 'algorithms/histograms'
require 'algorithms/histogram'
require 'sheep'
require 'progressbar'

class Array
  def avg_point
    transpose.map{|v|v.inject(:+)/v.size}
  end
end

module Algorithms
  class Multi
    include Histograms

    def initialize sheep, memory_size, io=$stderr
      memory = memory_size.to_i
      grid_number = initial_grid_number memory
      sheeps = initial_sheeps sheep, grid_number

      now_grid_number = sheeps.size
      now_sheeps = sheeps
      now_area = sheeps.map(&:area).inject(:+)

      #p now_grid_number
      pbar = ProgressBar.new('Calculate a histogram', now_grid_number, io)
      candidates = now_grid_number.downto(1).map do |grid_number|
        result = [now_area/cell_number(memory, grid_number), now_sheeps]
        unless now_sheeps.one?
          victim = now_sheeps.combination(2).map do |s1,s2|
            minx = [s1.minx, s2.minx].min
            maxx = [s1.maxx, s2.maxx].max
            miny = [s1.miny, s2.miny].min
            maxy = [s1.maxy, s2.maxy].max
            [(maxx-minx)*(maxy-miny)-s1.area-s2.area,s1,s2]
          end.min
          new_sheep = Sheep.new
          new_sheep.objects = victim[1].objects + victim[2].objects
          next_sheeps = now_sheeps.dup
          next_sheeps.delete(victim[2])
          next_sheeps.delete(victim[1])
          next_sheeps << new_sheep
          next_area = now_area + victim[0]

          now_sheeps = next_sheeps
          now_area = next_area
        end
        pbar.inc
        result
      end
      pbar.finish
      sheeps = candidates.min[1]

      sheeps.sort_by! {|s| -s.area}

      area = sheeps.map(&:area).inject(:+)
      grid_number = sheeps.size

      @histograms = sheeps.map.with_index do |sheep, idx|
        n, m = n_m_for_a_grid memory, grid_number, area, sheep

        memory -= sizeof_grid n, m
        grid_number -= 1
        area -= sheep.area

        Algorithms::Histogram.new sheep, n, m
      end
      $logger.error('Algorithms::Multi') do
        'memory limit: %d, memory used: %d' % [memory_size, @histograms.map{|h| sizeof_grid h.stepx, h.stepy}.inject(:+)]
      end if memory_size < @histograms.map{|h| sizeof_grid h.stepx, h.stepy}.inject(:+)
    end

    def initial_sheeps sheep, grid_number
      n = m = Math.sqrt(grid_number).floor
      sheeps = Array.new(n*m) { Sheep.new.tap{|s|s.objects=[]} }
      sheep.objects.each do |object|
        avg = object.avg_point
        idxx = ((avg[1] - sheep.miny) * n / (sheep.maxy - sheep.miny)).floor
        idxy = ((avg[0] - sheep.minx) * m / (sheep.maxx - sheep.minx)).floor
        sheeps[idxx*n+idxy].objects << object
      end
      sheeps.reject!{|s|s.objects.empty?}
      sheeps.each{|s|s.objects = s.objects}
      sheeps
    end

    def initial_grid_number memory
      memory/16
    end

    def cell_number memory, grid_number
      memory/16 - 3*grid_number/4
    end

    def sizeof_grid x, y
      4+4+2+2 + 16*x*y - 8*x - 8*y + 4
    end

    def n_m_for_a_grid memory, grid_number, area, sheep
      value = ((memory - grid_number * (4+4+2+2))*sheep.area / area).floor
      alpha = 4*Math.sqrt(sheep.area/value)
      n = ((sheep.maxy-sheep.miny)/alpha).floor
      m = ((sheep.maxx-sheep.minx)/alpha).floor
      [n,m]
    end
  end
end
