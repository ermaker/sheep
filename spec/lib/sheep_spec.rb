require 'sheep'
require 'stringio'

def fixture filename
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

def tmp filename
  File.join(File.dirname(__FILE__), '..', '..', 'tmp', filename)
end

describe Sheep do
  context '#convert' do
    it 'works' do
      result = StringIO.new
      File.stub(:open).with(fixture('3.data')).and_yield(
        StringIO.new(File.read(fixture('3.data'))))
      File.stub(:open).with(tmp('3.map'), 'w').and_yield(result)
      subject.convert fixture('3.data'), tmp('3.map')
      result.string.should == File.read(fixture('3.map'))
    end
  end

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
      objects = [
        [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
        [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
        [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
      ]
      subject.instance_eval('@objects = objects')
      subject.capture tmp('capture.jpg')
    end
  end
end
