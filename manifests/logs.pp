# Class stack_logstash::logs
#
class stack_logstash::logs {
  
  $logs = hiera_hash('stack_logstash::logs', {})
  validate_hash($logs)
  create_resources('::stack_logstash::log', $logs )

}
