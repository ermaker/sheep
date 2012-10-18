require 'log_config'

RSpec.configure do |config|
  config.around(:each) do |example|
    prev_logger, $logger = $logger, Logger.new(nil)
    example.run
    $logger.close
    $logger = prev_logger
  end
end

def fixture filename
    File.join(File.dirname(caller.first[/^.*:/]), 'fixtures', filename)
end

def tmp filename
    File.join(File.dirname(__FILE__), '..', 'tmp', filename)
end
