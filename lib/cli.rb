require 'farm'
require 'sheep'
require 'query'
require 'algorithms/histogram'
require 'algorithms/simple'
require 'yaml'

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

    def filename_hist map, memory, method
      dirname = File.dirname(map)
      basename = File.basename(map, File.extname(map))
      File.join(dirname, "#{basename}_#{memory}_#{method}.hist")
    end

    def make_hist map, memory, method
      farm = Farm.new
      farm.sheep = Sheep.new
      farm.sheep.load map
      case method
      when :histogram
        farm.set_algorithm Algorithms.const_get(method.capitalize), Math.sqrt(memory*1024*1024).to_i, Math.sqrt(memory*1024*1024).to_i
      when :simple
        farm.set_algorithm Algorithms.const_get(method.capitalize), ((memory*1024*1024)**(1.0/3)).to_i, ((memory*1024*1024)**(1.0/3)).to_i, ((memory*1024*1024)**(1.0/3)).to_i
      end
      farm.data
      File.open(filename_hist(map, memory, method), 'w') do |f|
        f << farm.to_yaml
      end
    end
  end
end
