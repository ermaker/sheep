require 'cli'

#data = Dir['data/*.data']
data = ["data/Wellington.data", "data/Nanaimo.data", "data/Sequoia.data"]
number = [1000000]
memory = [0.5, 1.0, 2.0]
method = [:histogram, :simple]
area = [0.01, 0.05, 0.1]
dist = [:random]
measure = [:absolute, :relative]

CLI.make_makefile data, number, memory, method, area, dist, measure
