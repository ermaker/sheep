require 'farm'

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
    end
  end
end
