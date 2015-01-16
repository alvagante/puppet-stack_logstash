# Class stack_logstash 
#
class stack_logstash (

  $logs_define                      = '::stack_logstash::log',

  $shipper_class                    = '::stack_logstash::shipper::rsyslog',
  $syslog_server                    = '',
  $syslog_server_port               = '5544',

  $elasticsearch_class              = undef,
  $elasticsearch_protocol           = 'http',
  $elasticsearch_server             = [ ],
  $elasticsearch_server_port        = '9200',

  $logstash_class                   = undef,

  $kibana_class                     = undef,

  $monitor_class                    = undef,
  $firewall_class                   = undef,

  ) {

  $array_elasticsearch_server=any2array($elasticsearch_server)

  if $shipper_class {
    include $shipper_class
  }

  if $logstash_class {
    include $logstash_class
  }

  if $elasticsearch_class {
    include $elasticsearch_class
  }

  if $kibana_class {
    include $kibana_class
  }

  if $monitor_class {
    include $monitor_class
  }

  if $firewall_class {
    include $firewall_class
  }

  $logs = hiera_hash('stack_logstash::logs', {})
  validate_hash($logs)
  create_resources($logs_define, $logs)

}
