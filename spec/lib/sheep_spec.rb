require 'spec_helper'
require 'sheep'

describe Sheep do
  context '#load' do
    it 'reads map with 1.map' do
      map = fixture('1.map')
      subject.load map
      subject.objects.should == []
    end
    it 'reads map with 2.map' do
      map = fixture('2.map')
      subject.load map
      subject.objects.should == [[[1.0,1.0],[2.0,1.0],[2.0,2.0],[1.0,2.0]]]

      subject.minx.should == 1.0
      subject.miny.should == 1.0
      subject.maxx.should == 2.0
      subject.maxy.should == 2.0
    end
    it 'reads map with 3.map' do
      map = fixture('3.map')
      subject.load map
      subject.objects.should == [
        [[10000.0,10000.0],[20000.0,10000.0],[20000.0,20000.0],[10000.0,20000.0]],
        [[30000.0,30000.0],[40000.0,30000.0],[40000.0,40000.0],[30000.0,40000.0]],
      ]

      subject.minx.should == 10000.0
      subject.miny.should == 10000.0
      subject.maxx.should == 40000.0
      subject.maxy.should == 40000.0
    end
    it 'raises an error with _1.map' do
      expect do
      map = fixture('_1.map')
      subject.load map
      end.to raise_error Sheep::NUMBEROF_OBJECTS_NOT_MATCHED
    end
    it 'raises an error with _2.map' do
      expect do
      map = fixture('_2.map')
      subject.load map
      end.to raise_error Sheep::NUMBEROF_POINTS_NOT_MATCHED
    end
  end

  context '#capture', :if => false do
    it 'works' do
      subject.objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      subject.capture tmp('capture.jpg')
    end
  end
end
