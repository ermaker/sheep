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
end
