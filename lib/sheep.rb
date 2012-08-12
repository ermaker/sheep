class Sheep
  class NUMBEROF_OBJECTS_NOT_MATCHED < Exception; end
  class NUMBEROF_POINTS_NOT_MATCHED < Exception; end

  attr_reader :objects

  def load filename
    open(filename) do |file|
      numberof_objects = file.readline.to_i
      @objects = file.each_line.map do |line|
        numberof_points, *points = line.split
        numberof_points = numberof_points.to_i
        points = points.map(&:to_f).each_slice(2).to_a
        raise NUMBEROF_POINTS_NOT_MATCHED unless numberof_points == points.size
        points
      end
      raise NUMBEROF_OBJECTS_NOT_MATCHED unless numberof_objects == @objects.size
    end
  end
end
