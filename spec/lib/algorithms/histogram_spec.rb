require 'algorithms/histogram'
require 'sheep'
require 'stringio'

describe Algorithms::Histogram do
  subject do
    described_class.new(
      double(
        :objects => [
          [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
          [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
          [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ],
        :euler_histogram => [
          [1, -1, 2],
          [-1, 1, -1],
          [2, -2, 2],
    ],
    :minx => 0.0, :miny => 0.0, :maxx => 6.0, :maxy => 8.0), 2, 2)
  end

  context '#bounds' do
    it 'works' do
      subject.bounds(0.0, 0.0, 6.0, 8.0).should == [
        [0, 0, 2, 2],
        [0, 0, 2, 2],
        [0.0, 0.0, 8.0, 6.0],
        [0.0, 0.0, 8.0, 6.0],
      ]
      subject.bounds(4.0, 2.0, 5.0, 3.0).should == [
        [1, 2, 0, 1],
        [0, 1, 1, 2],
        [4.0, 6.0, 0.0, 3.0],
        [0.0, 3.0, 4.0, 6.0],
      ]
      subject.bounds(3.0, 5.0, 4.0, 6.0).should == [
        [2, 1, 1, 1],
        [1, 1, 2, 2],
        [8.0, 3.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(3.0, 4.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [1, 1, 2, 2],
        [4.0, 3.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(4.0, 4.0, 5.0, 5.0).should == [
        [1, 2, 1, 1],
        [1, 1, 2, 2],
        [4.0, 6.0, 4.0, 3.0],
        [4.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(3.0, 2.0, 5.0, 6.0).should == [
        [1, 1, 1, 1],
        [0, 1, 2, 2],
        [4.0, 3.0, 4.0, 3.0],
        [0.0, 3.0, 8.0, 6.0],
      ]
    end

    it 'works with special cases' do
      subject.bounds(-100.0, -100.0, 100.0, 100.0).should == [
        [0, 0, 2, 2],
        [0, 0, 2, 2],
        [0.0, 0.0, 8.0, 6.0],
        [0.0, 0.0, 8.0, 6.0],
      ]
      subject.bounds(-100.0, -100.0, -50.0, -50.0).should == [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0.0, 0.0, 0.0, 0.0],
        [0.0, 0.0, 0.0, 0.0],
      ]
      subject.bounds(3.0, -10.0, 10.0, 50.0).should == [
        [0, 1, 2, 2],
        [0, 1, 2, 2],
        [0.0, 3.0, 8.0, 6.0],
        [0.0, 3.0, 8.0, 6.0],
      ]
      subject.bounds(7.0, 9.0, 9.0, 11.0).should == [
        [2, 2, 2, 2],
        [2, 2, 2, 2],
        [8.0, 6.0, 8.0, 6.0],
        [8.0, 6.0, 8.0, 6.0],
      ]
    end
  end

  context '#exact_query' do
    before do
      subject.data StringIO.new
    end

    it 'works' do
      subject.exact_query(0, 0, 1, 1).should == 1
      subject.exact_query(0, 0, 1, 2).should == 2
      subject.exact_query(0, 0, 2, 1).should == 2
      subject.exact_query(0, 0, 2, 2).should == 3
      subject.exact_query(0, 1, 1, 2).should == 2
      subject.exact_query(0, 1, 2, 2).should == 3
      subject.exact_query(1, 0, 2, 1).should == 2
      subject.exact_query(1, 0, 2, 2).should == 2
      subject.exact_query(1, 1, 2, 2).should == 2
    end

    it 'works with special cases' do
      subject.exact_query(0, 0, 0, 0).should == 0
      subject.exact_query(1, 1, 1, 1).should == 0
      subject.exact_query(0, 1, 1, 1).should == 0
      subject.exact_query(1, 0, 1, 1).should == 0
      subject.exact_query(1, 1, 0, 0).should == 0
      subject.exact_query(1, 0, 0, 0).should == 0
      subject.exact_query(0, 1, 0, 0).should == 0
    end
  end

  context '#area' do
    it 'works' do
      subject.area(0.0, 0.0, 6.0, 8.0).should == 48.0
      subject.area(4.0, 2.0, 5.0, 3.0).should == 1.0
      subject.area(3.0, 5.0, 4.0, 6.0).should == 1.0
      subject.area(3.0, 4.0, 5.0, 6.0).should == 4.0
      subject.area(4.0, 4.0, 5.0, 5.0).should == 1.0
      subject.area(3.0, 2.0, 5.0, 6.0).should == 8.0
    end

    it 'works with special cases' do
      subject.area(0.0, 0.0, 0.0, 0.0).should == 0.0
      subject.area(0.0, 0.0, 1.0, 0.0).should == 0.0
      subject.area(0.0, 0.0, 0.0, 1.0).should == 0.0
      subject.area(1.0, 1.0, 0.0, 0.0).should == 0.0
      subject.area(1.0, 0.0, 0.0, 0.0).should == 0.0
      subject.area(0.0, 1.0, 0.0, 0.0).should == 0.0
      subject.area(1.0, 0.0, 0.0, 1.0).should == 0.0
      subject.area(0.0, 1.0, 1.0, 0.0).should == 0.0
    end
  end

  context '#query' do
    before do
      subject.data StringIO.new
    end
    it 'works' do
      subject.query(0.0, 0.0, 6.0, 8.0).should == 3
      subject.query(4.0, 2.0, 5.0, 3.0).should == 1.0/6.0
      subject.query(3.0, 5.0, 4.0, 6.0).should == 1.0/6.0
      subject.query(3.0, 4.0, 5.0, 6.0).should == 2.0/3.0
      subject.query(4.0, 4.0, 5.0, 5.0).should == 1.0/6.0
      subject.query(3.0, 2.0, 5.0, 6.0).should == 1.0
    end

    it 'works with special cases' do
      subject.query(-100.0, -100.0, 100.0, 100.0).should == 3
      subject.query(-100.0, -100.0, -50.0, -50.0).should == 0
      subject.query(3.0, -10.0, 10.0, 50.0).should == 3
      subject.query(7.0, 9.0, 9.0, 11.0).should == 0

      subject.query(4.0, 4.0, 6.0, 8.0).should == 1.3333333333333333
      subject.query(4.0, 4.0, 100.0, 100.0).should == 1.3333333333333333
    end
  end
end

describe Algorithms::Histogram, 'with special objects' do
  subject do
    s = Sheep.new
    s.objects = [
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
    ]
    described_class.new(s, 2, 2)
  end

  context '#query' do
    it 'works' do
      subject.data StringIO.new

      subject.query(4.0, 2.0, 5.0, 3.0).should_not be_nan
      subject.query(4.0, 2.0, 5.0, 3.0).should == 0.0
    end
  end
end

describe Algorithms::Histogram, 'with memory size' do
  subject do
    s = Sheep.new
    s.objects = [
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
    ]
    described_class.new(s, 1024)
  end

  it 'has the correct size' do
    subject.stepx.should == 7
    subject.stepy.should == 7
  end
end

describe Algorithms::Histogram do
  subject do
    s = Sheep.new
    s.objects = [
      [[2.0,1.0],[4.0,1.0],[4.0,6.0],[2.0,6.0]],
      [[1.0,5.0],[5.0,5.0],[5.0,7.0],[1.0,7.0]],
      [[4.0,2.0],[5.0,2.0],[5.0,3.0],[4.0,3.0]],
    ]
    s = described_class.new(s, 2, 2)
    s.minx = 0.0
    s.miny = 0.0
    s.maxx = 6.0
    s.maxy = 8.0
    s
  end

  context '#euler_histogram_step' do
    it 'works if the target is a point' do
      result = subject.euler_histogram_step(1, 1)
      result.should == 1
    end
    it 'works if the target is a segment' do
      result = subject.euler_histogram_step(0, 1)
      result.should == -1
      result = subject.euler_histogram_step(1, 0)
      result.should == -1
      result = subject.euler_histogram_step(1, 2)
      result.should == -1
      result = subject.euler_histogram_step(2, 1)
      result.should == -2
    end
    it 'works if the target is a cell' do
      result = subject.euler_histogram_step(0, 0)
      result.should == 1
      result = subject.euler_histogram_step(0, 2)
      result.should == 2
      result = subject.euler_histogram_step(2, 0)
      result.should == 2
      result = subject.euler_histogram_step(2, 2)
      result.should == 2
    end
  end

  context '#euler_histogram' do
    it 'works' do
      subject.stepx = 2
      subject.stepy = 2
      result = subject.euler_histogram double(:inc => nil)
      result.should == [
        [1, -1, 2],
        [-1, 1, -1],
        [2, -2, 2],
      ]

      subject.stepx = 3
      subject.stepy = 2
      result = subject.euler_histogram double(:inc => nil)
      result.should == [
        [1, -1, 2],
        [-1, 1, -2],
        [2, -2, 3],
        [-2, 2, -2],
        [2, -2, 2],
      ]

      subject.stepx = 3
      subject.stepy = 3
      result = subject.euler_histogram double(:inc => nil)
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

describe Algorithms::Histogram do
  subject do
    described_class.new(
      double(
        :objects => [
          [[1.0,1.0],[7.0,1.0],[7.0,9.0],[1.0,9.0]],
          [[3.0,3.0],[7.0,3.0],[7.0,7.0],[3.0,7.0]],
          [[0.5,0.5],[1.5,0.5],[1.5,1.5],[0.5,1.5]],
          [[1.0,4.5],[5.0,4.5],[5.0,5.5],[1.0,5.5]],
    ],
    :minx => 0.0, :miny => 0.0, :maxx => 8.0, :maxy => 10.0), 5, 4)
  end

  before do
    @uidxs = subject.sheep.objects.map do |object|
      subject.get_uidx object
    end
    @step0s = subject.sheep.objects.zip(@uidxs).map do |object,uidx|
      subject.step0 uidx
    end
    @polygons = subject.sheep.objects.map do |object|
      subject.get_polygon object
    end
  end

  context '#get_uidx' do
    it 'works' do
      @uidxs.should == [
        [0, 0, 5, 4],
        [1, 1, 4, 4],
        [0, 0, 1, 1],
        [2, 0, 3, 3],
      ]
    end
  end

  context '#step0' do
    it 'works' do
      result = @step0s.map {|r| [r.size, (r[0]||[]).size]}
      result.should == [
        [9, 7],
        [5, 5],
        [1, 1],
        [1, 5],
      ]
    end
  end

  context '#step1' do
    it 'works' do
      result = @polygons.zip(@step0s, @uidxs).map do |polygon,step0,uidx|
        subject.step1 step0, uidx, polygon
      end
      result.should == [
        [
          [ 1, -1,  1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1, -1,  1]
        ],
        [
          [ 1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1],
          [-1,  1, -1,  1, -1],
          [ 1, -1,  1, -1,  1]
        ],
        [[0]],
        [[0, 0, 0, 0, 0]],
      ]
    end
  end

  context '#step2' do
    it 'works' do
      result = @polygons.zip(@step0s, @uidxs).map do |polygon,step0,uidx|
        subject.step2 step0, uidx, polygon
      end
      result.should == [
        [
          [1, -1, 1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1, -1, 1]
        ],
        [
          [1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0],
          [1, -1, 1, -1, 1]
        ],
        [[0]],
        [[1, -1, 1, -1, 1]],
      ]
    end
  end

  context '#step3' do
    it 'works' do
      result = @polygons.zip(@step0s, @uidxs).map do |polygon,step0,uidx|
        subject.step3 step0, uidx, polygon
      end
      result.should == [
        [
          [1, 0, 1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1, 0, 1]
        ],
        [
          [1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1],
          [-1, 0, -1, 0, -1],
          [1, 0, 1, 0, 1]
        ],
        [[0]],
        [[0, 0, 0, 0, 0]]
      ]
    end
  end

  context '#step4' do
    it 'works' do
      result = @polygons.zip(@step0s, @uidxs).map do |polygon,step0,uidx|
        subject.step4 step0, uidx, polygon
      end
      result.should == [
        [
          [1, 0, 1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1, 0, 1]
        ],
        [
          [1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1],
          [0, 0, 0, 0, 0],
          [1, 0, 1, 0, 1]
        ],
        [[1]],
        [[1, 0, 1, 0, 1]]
      ]
    end
  end

  context '#step5' do
    it 'works' do
      result = @polygons.zip(@step0s, @uidxs).map do |polygon,step0,uidx|
        result = subject.get_result
        step1 = subject.step1 step0, uidx, polygon
        subject.step5 result, step1, uidx
      end
      result.should == [
        [
          [1, -1, 1, -1, 1, -1, 1],
          [-1, 1, -1, 1, -1, 1, -1],
          [1, -1, 1, -1, 1, -1, 1],
          [-1, 1, -1, 1, -1, 1, -1],
          [1, -1, 1, -1, 1, -1, 1],
          [-1, 1, -1, 1, -1, 1, -1],
          [1, -1, 1, -1, 1, -1, 1],
          [-1, 1, -1, 1, -1, 1, -1],
          [1, -1, 1, -1, 1, -1, 1]
        ],
        [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 1, -1, 1, -1, 1],
          [0, 0, -1, 1, -1, 1, -1],
          [0, 0, 1, -1, 1, -1, 1],
          [0, 0, -1, 1, -1, 1, -1],
          [0, 0, 1, -1, 1, -1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0]
        ],
        [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0]
        ],
        [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0]
        ]
      ]
    end
  end

  context '#histogram' do
    it 'works' do
      subject.histogram(double(:inc => nil)).should == [
        [2, 1, 2, 1, 2, 1, 2],
        [1, 1, 1, 1, 1, 1, 1],
        [2, 1, 3, 1, 3, 1, 3],
        [1, 1, 1, 1, 1, 1, 1],
        [3, 1, 4, 1, 4, 2, 4],
        [2, 1, 2, 1, 2, 2, 2],
        [3, 1, 4, 1, 4, 2, 4],
        [2, 1, 3, 1, 3, 2, 3],
        [3, 1, 4, 1, 4, 2, 4]
      ]
    end
  end
end
