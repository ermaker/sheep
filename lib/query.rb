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
        f << queries.to_yaml
      end
    end

    def load filename
      YAML.load(File.read(filename))
    end
  end
end
