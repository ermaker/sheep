require 'farm'
require 'RMagick'
require 'progressbar'

module Capturable
  def capture filename
    scale = 10000 / Farm.scale
    margin = 200

    points = capture_points
    minmax = [points.map{|v|v[0]}.minmax, points.map{|v|v[1]}.minmax]
    size = minmax.map{|v| v[1]}

    canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
    pbar = ProgressBar.new('Draw objects', capture_size)
    gc = Magick::Draw.new
    _capture gc, scale, pbar
    pbar.finish
    gc.draw(canvas)
    canvas.flip!
    canvas.write(filename)
  end
end
