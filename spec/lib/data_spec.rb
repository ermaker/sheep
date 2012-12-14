require 'spec_helper'
require 'data'

describe Data do
  context '.generate' do
    it 'works' do
      srand 0

      file_io = StringIO.new
      File.stub(:open).and_yield(file_io)
      Data.generate fixture('map100.map'), 100

      file_io.string.should == File.read(fixture('map100.map'))
    end
  end
end
