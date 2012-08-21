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
    end
    it 'reads map with 3.map' do
      map = fixture('3.map')
      subject.load map
      subject.objects.should == [
        [[1.0,1.0],[2.0,1.0],[2.0,2.0],[1.0,2.0]],
        [[3.0,3.0],[4.0,3.0],[4.0,4.0],[3.0,4.0]],
      ]
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

  context '#euler_histogram_step' do
    it 'works if the target is a point' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 1, 1)
      result.should == 1
    end
    it 'works if the target is a segment' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 0, 1)
      result.should == -1
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 1, 0)
      result.should == -1
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 1, 2)
      result.should == -1
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 2, 1)
      result.should == -2
    end
    it 'works if the target is a cell' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 0, 0)
      result.should == 1
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 0, 2)
      result.should == 2
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 2, 0)
      result.should == 2
      result = subject.euler_histogram_step(
        objects, 0.0, 0.0, 6.0, 8.0, 2, 2, 2, 2)
      result.should == 2
    end
  end

  context '#euler_histogram' do
    it 'works' do
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      result = subject.euler_histogram objects, 0.0, 0.0, 6.0, 8.0, 2, 2
      result.should == [
        [1, -1, 2],
        [-1, 1, -1],
        [2, -2, 2],
      ]

      result = subject.euler_histogram objects, 0.0, 0.0, 6.0, 8.0, 3, 2
      result.should == [
        [1, -1, 2],
        [-1, 1, -2],
        [2, -2, 3],
        [-2, 2, -2],
        [2, -2, 2],
      ]

      result = subject.euler_histogram objects, 0.0, 0.0, 6.0, 8.0, 3, 3
      result.should == [
        [0, 0, 1, 0, 1],
        [0, 0, -1, 0, -1],
        [1, -1, 2, -1, 2],
        [-1, 1, -2, 1 ,-1],
        [1, -1, 2, -1, 1],
      ]
    end
  end
end
