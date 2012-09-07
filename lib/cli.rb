require 'farm'
require 'sheep'
require 'query'
require 'algorithms/naive'
require 'algorithms/histogram'
require 'algorithms/simple'
require 'yaml'
require 'stringio'

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

    def filename_sel query
      dirname = File.dirname(query)
      basename = File.basename(query, File.extname(query))
      File.join(dirname, "#{basename}.sel")
    end

    def make_sel query
      dirname = File.dirname(query)
      basename = File.basename(query, File.extname(query))
      map = File.join(dirname, "#{basename.split('_')[0]}.map")

      farm = Farm.new
      farm.sheep = Sheep.new
      farm.sheep.load map
      farm.set_algorithm Algorithms::Naive
      queries = Query.load query
      sel = queries.map {|query| farm.query(*query)}
      File.open(filename_sel(query), 'w') do |f|
        f<< sel.to_yaml
      end
    end

    def filename_est hist, query
      dirname = File.dirname(hist)
      basename = File.basename(hist, File.extname(hist))
      query_basename = File.basename(query, File.extname(query))
      File.join(dirname, "#{basename}_#{query_basename.split('_')[1..-1].join('_')}.est")
    end

    def make_est hist, query
      farm = YAML.load(File.read(hist))
      queries = Query.load query
      est = queries.map {|query| farm.query(*query)}
      File.open(filename_est(hist, query), 'w') do |f|
        f<< est.to_yaml
      end
    end

    def make_makefile data, number, memory, method, area, dist, measure
      output = StringIO.new
      all_files = []

      data.each do |data_|
        all_files << filename_map(data_)
        output.puts <<-EOS
#{filename_map(data_)}: #{data_}
\t$(SHEEP) 'CLI.make_map "#{data_}"'

        EOS
      end

      data.each do |data_|
        number.each do |number_|
          area.each do |area_|
            dist.each do |dist_|
              all_files << filename_query(filename_map(data_), number_, area_, dist_)
              output.puts <<-EOS
#{filename_query(filename_map(data_), number_, area_, dist_)}: #{filename_map(data_)}
\t$(SHEEP) 'CLI.make_query "#{filename_map(data_)}", #{number_}, #{area_}, :#{dist_}'

              EOS
              all_files << filename_sel(filename_query(filename_map(data_), number_, area_, dist_))
              output.puts <<-EOS
#{filename_sel(filename_query(filename_map(data_), number_, area_, dist_))}: #{filename_map(data_)} #{filename_query(filename_map(data_), number_, area_, dist_)}
\t$(SHEEP) 'CLI.make_sel "#{filename_query(filename_map(data_), number_, area_, dist_)}"'

              EOS
            end
          end
        end
      end

      data.each do |data_|
        memory.each do |memory_|
          method.each do |method_|
            all_files << filename_hist(filename_map(data_), memory_, method_)
            output.puts <<-EOS
#{filename_hist(filename_map(data_), memory_, method_)}: #{filename_map(data_)}
\t$(SHEEP) 'CLI.make_hist "#{filename_map(data_)}", #{memory_}, :#{method_}'

            EOS
          end
        end
      end
      File.open('Makefile', 'w') do |f|
        f.puts 'SHEEP = ruby -Ilib -rcli -e'
        f.puts
        f.puts "default: #{all_files.join(' ')}"
        f.puts
        f.puts output.string
      end
    end
  end
end
