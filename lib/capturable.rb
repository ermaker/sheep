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
    $logger.debug('Capturable#capture') { 'size: %s' % size.to_s }

    canvas = Magick::Image.new(*size.map{|v|v*scale+margin})
    $logger.debug('Capturable#capture') { 'image size: %s' % size.map{|v|v*scale+margin}.to_s }
    pbar = ProgressBar.new('Draw objects', capture_size)
    gc = Magick::Draw.new
    _capture gc, scale, pbar
    pbar.finish
    $logger.debug('Capturable#capture') { 'draw' }
    gc.draw(canvas)
    $logger.debug('Capturable#capture') { 'flip!' }
    canvas.flip!
    $logger.debug('Capturable#capture') { 'write' }
    canvas.write(filename)
    $logger.debug('Capturable#capture') { 'end' }
  end
end
