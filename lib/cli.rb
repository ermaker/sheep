require 'farm'
require 'sheep'
require 'query'

class CLI
  class << self
    def filename_map data
      File.join(
        File.dirname(data),
        File.basename(data, File.extname(data))+'.map')
    end

    def make_map data, io=STDERR
      Farm.convert data, filename_map(data), io
    end

    def filename_query map, number, area, dist
      dirname = File.dirname(map)
      basename = File.basename(map, File.extname(map))
      File.join(dirname, "#{basename}_#{number}_#{area}_#{dist}.query")
    end

    def make_query map, number, area, dist
      sheep = Sheep.new
      sheep.load map
      queries = number.times.map do
        Query.generate sheep, area
      end
      Query.save filename_query(map, number, area, dist), queries
    end
  end
end
