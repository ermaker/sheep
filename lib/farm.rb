require 'progressbar'

class Farm
  class INVALID_FORMAT < Exception; end

  class << self
    def convert source, destination, io=STDERR
      File.open(source, 'rt') do |input|
        File.open(destination, 'w') do |output|
          raise INVALID_FORMAT unless input.readline =~ /^dimension=2$/
          raise INVALID_FORMAT unless input.readline =~ /^numPolygons=(\d+)$/
          output.puts $1.to_i
          begin
            pbar = ProgressBar.new('Convert objects', $1.to_i, io)
            loop do
              raise INVALID_FORMAT unless input.readline =~ /^numVertices=(\d+)$/
              output.print "#{$1.to_i-1} "
              output.puts((1..$1.to_i).map do |idx|
                input.readline.split.map(&:to_f)
              end[0..-2].flatten.join(' '))
              pbar.inc
            end
            pbar.finish
          rescue EOFError
          end
        end
      end
    end
  end

  attr_accessor :sheep

  def set_algorithm value, *args
    @algorithm_class = value
    @algorithm = @algorithm_class.new @sheep, *args
  end

  def data io=$stderr
    @algorithm.data io
  end

  def query minx, miny, maxx, maxy
    @algorithm.query minx, miny, maxx, maxy
  end
end
