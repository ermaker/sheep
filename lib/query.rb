require 'yaml'

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
end
