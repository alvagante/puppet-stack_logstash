# Class stack_logstash
#
class stack_logstash (

  $syslog_class                     = 'stack_logstash::syslog',
  $syslog_config_template           = 'stack_logstash/syslog.conf.erb',
  $syslog_config_hash               = { },
  $syslog_server                    = false,
  $syslog_files                     = '*.*',
  $syslog_server_port               = '5544',

  $elasticsearch_class              = 'stack_logstash::elasticsearch',
  $elasticsearch_config_template    = 'stack_logstash/elasticsearch.yml.erb',
  $elasticsearch_config_hash        = { },
  $elasticsearch_protocol           = 'http',
  $elasticsearch_server             = '',
  $elasticsearch_server_port        = '9200',
  $elasticsearch_cluster_name       = 'logs',
  $elasticsearch_java_heap_size     = '1024',
  $elasticsearch_version            = '1.0.1',

  $logstash_class                   = 'stack_logstash::logstash',
  $logstash_config_template         = 'stack_logstash/logstash.conf.erb',
  $logstash_config_hash             = { },

  $kibana_class                     = 'stack_logstash::kibana',
  $kibana_config_template           = undef,
  $kibana_config_hash               = { },

  $monitor_class                    = undef,
  $firewall_class                   = undef,

  ) {

  $real_elasticsearch_server = $elasticsearch_server ? {
    # query_nodes('Class[elasticsearch]{tags=stack::logstash}',ipaddress), #
    # TODO: Fix query
    ''      => query_nodes('Class[elasticsearch]',ipaddress),
    default => $elasticsearch_server,
  }

  if $syslog_server
  and $syslog_class {
    include $syslog_class
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

}
