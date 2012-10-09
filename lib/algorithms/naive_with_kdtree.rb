require 'kdtree/factory'
require 'kdtree_query_c'

module Algorithms
  class NaiveWithKdtree
    attr_accessor :objects

    def initialize sheep
      @objects = sheep.objects
      @kdtree = Kdtree::Factory.make @objects
    end

    def query minx, miny, maxx, maxy
      #@kdtree.query minx, miny, maxx, maxy
      #Kdtree::Factory.query @kdtree, minx, miny, maxx, maxy
      Kdtree::Factory.query_c @kdtree, minx, miny, maxx, maxy
    end
  end
end
