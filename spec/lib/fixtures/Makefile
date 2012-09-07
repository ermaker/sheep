SHEEP = ruby -Ilib -rcli -e

default: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.sel /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.sel /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.sel /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.1_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.1_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.1_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.1_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.1_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.01_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.05_random.est /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.1_random.est

/home/mwlee/proj/sheep/spec/lib/fixtures/3.map: /home/mwlee/proj/sheep/spec/lib/fixtures/3.data
	$(SHEEP) 'CLI.make_map "/home/mwlee/proj/sheep/spec/lib/fixtures/3.data"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_query "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 100, 0.01, :random'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.sel: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query
	$(SHEEP) 'CLI.make_sel "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_query "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 100, 0.05, :random'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.sel: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query
	$(SHEEP) 'CLI.make_sel "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_query "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 100, 0.1, :random'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.sel: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query
	$(SHEEP) 'CLI.make_sel "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.001, :histogram'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.001, :simple'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.005, :histogram'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.005, :simple'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.01, :histogram'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist: /home/mwlee/proj/sheep/spec/lib/fixtures/3.map
	$(SHEEP) 'CLI.make_hist "/home/mwlee/proj/sheep/spec/lib/fixtures/3.map", 0.01, :simple'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.001_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.005_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_histogram.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.01_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.01_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.05_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.05_random.query"'

/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple_100_0.1_random.est: /home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query /home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist
	$(SHEEP) 'CLI.make_est "/home/mwlee/proj/sheep/spec/lib/fixtures/3_0.01_simple.hist", "/home/mwlee/proj/sheep/spec/lib/fixtures/3_100_0.1_random.query"'

