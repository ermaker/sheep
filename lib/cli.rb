require 'farm'

class CLI
  class << self
    def make_map data, io=STDERR
      basename = File.join(
        File.dirname(data),
        File.basename(data, File.extname(data)))
      Farm.convert data, basename + '.map', io
    end
  end
end
