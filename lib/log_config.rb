require 'logger'

$logger = Logger.new('log.log')
#$logger.level = Logger::INFO
$logger.level = Logger::DEBUG

at_exit { $logger.close }
