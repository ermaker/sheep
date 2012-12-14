class Data

  def self.random_value max
    result = nil
    begin
      result = rand
    end until result < max
    return result
  end

  def self.generate filename, number
    dx = 0.0003
    dy = 0.0003
    File.open(filename, 'w') do |f|
      f.puts 'dimension=2'
      f.puts "numPolygons=#{number}"
      number.times do
        x = random_value 1-dx
        y = random_value 1-dy
        f.puts "numVertices=5"
        f.puts "#{x} #{y}"
        f.puts "#{x+dx} #{y}"
        f.puts "#{x+dx} #{y+dy}"
        f.puts "#{x} #{y+dy}"
        f.puts "#{x} #{y}"
      end
    end
  end
end
