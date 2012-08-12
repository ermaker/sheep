require 'sheep'

def path filename
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

describe Sheep do
  context '#load' do
    it 'reads map with 1.map' do
      map = path('1.map')
      subject.load map
      subject.objects.should == []
    end
    it 'reads map with 2.map' do
      map = path('2.map')
      subject.load map
      subject.objects.should == [[[1.0,1.0],[1.0,2.0],[2.0,2.0],[2.0,1.0]]]
    end
    it 'reads map with 3.map' do
      map = path('3.map')
      subject.load map
      subject.objects.should == [
        [[1.0,1.0],[1.0,2.0],[2.0,2.0],[2.0,1.0]],
        [[3.0,3.0],[3.0,4.0],[4.0,4.0],[4.0,3.0]],
      ]
    end
    it 'raises an error with _1.map' do
      expect do
      map = path('_1.map')
      subject.load map
      end.to raise_error Sheep::NUMBEROF_OBJECTS_NOT_MATCHED
    end
    it 'raises an error with _2.map' do
      expect do
      map = path('_2.map')
      subject.load map
      end.to raise_error Sheep::NUMBEROF_POINTS_NOT_MATCHED
    end
  end
end
