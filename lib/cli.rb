require 'log_config'
require 'farm'
require 'sheep'
require 'query'
require 'algorithms/naive_with_kdtree'
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

    def make_map data, io=$stderr
      Farm.convert data, filename_map(data), io
    end

    def filename_query map, number, area, dist
      dirname = File.dirname(map)
      basename = File.basename(map, File.extname(map))
      File.join(dirname, "#{basename}_#{number}_#{area}_#{dist}.query")
    end

    def make_query map, number, area, dist
      $logger.debug('CLI.make_query') {'new & load map'}
      sheep = Sheep.new
      sheep.load map
      $logger.debug('CLI.make_query') {'Query.generate'}
      queries = number.times.map do
        Query.generate sheep, area
      end
      $logger.debug('CLI.make_query') {'Query.save'}
      Query.save filename_query(map, number, area, dist), queries
      $logger.debug('CLI.make_query') {'end'}
    end

    def filename_hist map, memory, method
      dirname = File.dirname(map)
      basename = File.basename(map, File.extname(map))
      File.join(dirname, "#{basename}_#{memory}_#{method}.hist")
    end

    def make_hist map, memory, method, io=$stderr
      $logger.debug('CLI.make_hist') {'start'}
      farm = Farm.new
      farm.sheep = Sheep.new
      farm.sheep.load map
      $logger.debug('CLI.make_hist') {'set_algorithm'}
      farm.set_algorithm Algorithms.const_get(method.capitalize), memory*1024*1024
      $logger.debug('CLI.make_hist') {'data'}
      farm.data io
      $logger.debug('CLI.make_hist') {'file write'}
      File.open(filename_hist(map, memory, method), 'w') do |f|
        f << farm.to_yaml
      end
      $logger.debug('CLI.make_hist') {'end'}
    end

    def filename_sel query
      dirname = File.dirname(query)
      basename = File.basename(query, File.extname(query))
      File.join(dirname, "#{basename}.sel")
    end

    def make_sel query, io=$stderr
      dirname = File.dirname(query)
      basename = File.basename(query, File.extname(query))
      map = File.join(dirname, "#{basename.split('_')[0]}.map")

      farm = Farm.new
      farm.sheep = Sheep.new
      farm.sheep.load map
      $logger.debug('CLI.make_sel') {'set_algorithm'}
      farm.set_algorithm Algorithms::NaiveWithKdtree
      $logger.debug('CLI.make_sel') {'query start'}
      pbar = ProgressBar.new('Get result', Query.size(query), io)
      sel = Query.load(query) do |query|
        pbar.inc
        farm.query(*query)
      end
      pbar.finish
      $logger.debug('CLI.make_sel') {'file write'}
      File.open(filename_sel(query), 'w') do |f|
        f<< sel.to_yaml
      end
      $logger.debug('CLI.make_sel') {'end'}
    end

    def filename_est hist, query
      dirname = File.dirname(hist)
      basename = File.basename(hist, File.extname(hist))
      query_basename = File.basename(query, File.extname(query))
      File.join(dirname, "#{basename}_#{query_basename.split('_')[1..-1].join('_')}.est")
    end

    def make_est hist, query, io=$stderr
      $logger.debug('CLI.make_est') {'start'}
      $logger.debug('CLI.make_est') {'load farm'}
      farm = YAML.load(File.read(hist))
      pbar = ProgressBar.new('Get result', Query.size(query), io)
      $logger.debug('CLI.make_est') {'each query'}
      est = Query.load(query) do |query|
        pbar.inc
        farm.query(*query)
      end
      pbar.finish
      $logger.debug('CLI.make_est') {'file write'}
      File.open(filename_est(hist, query), 'w') do |f|
        f<< est.to_yaml
      end
      $logger.debug('CLI.make_est') {'end'}
    end

    def filename_err est, measure
      dirname = File.dirname(est)
      basename = File.basename(est, File.extname(est))
      File.join(dirname, "#{basename}_#{measure}.err")
    end

    def make_err est, measure
      dirname = File.dirname(est)
      basename = File.basename(est, File.extname(est)).split('_')
      sel = File.join(dirname, "#{([basename[0]]+basename[-3..-1]).join('_')}.sel")

      est_values = YAML.load(File.read(est))
      sel_values = YAML.load(File.read(sel))
      err = case measure
            when :absolute
              sel_values.zip(est_values).map{|s,e|(s-e).abs}
            when :relative
              sel_values.zip(est_values).map{|s,e|(s-e).abs/[s,1].max}
            end
      File.open(filename_err(est, measure), 'w') do |f|
        f<< err.to_yaml
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

      data.each do |data_|
        memory.each do |memory_|
          method.each do |method_|
            number.each do |number_|
              area.each do |area_|
                dist.each do |dist_|
                  all_files << filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_))
                  output.puts <<-EOS
#{filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_))}: #{filename_query(filename_map(data_), number_, area_, dist_)} #{filename_hist(filename_map(data_), memory_, method_)}
\t$(SHEEP) 'CLI.make_est "#{filename_hist(filename_map(data_), memory_, method_)}", "#{filename_query(filename_map(data_), number_, area_, dist_)}"'

                  EOS
                end
              end
            end
          end
        end
      end

      data.each do |data_|
        memory.each do |memory_|
          method.each do |method_|
            number.each do |number_|
              area.each do |area_|
                dist.each do |dist_|
                  measure.each do |measure_|
                    all_files << filename_err(filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_)), measure_)
                    output.puts <<-EOS
#{filename_err(filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_)), measure_)}: #{filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_))} #{filename_sel(filename_query(filename_map(data_), number_, area_, dist_))}
\t$(SHEEP) 'CLI.make_err "#{filename_est(filename_hist(filename_map(data_), memory_, method_), filename_query(filename_map(data_), number_, area_, dist_))}", :#{measure_}'

                  EOS
                  end
                end
              end
            end
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
