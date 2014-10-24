# Class stack_logstash
#
class stack_logstash (

  $repo_class                       = '::stack_logstash::repo',

  $syslog_class                     = undef,
  $syslog_config_template           = 'stack_logstash/syslog.conf.erb',
  $syslog_config_hash               = { },
  $syslog_server                    = false,
  $syslog_files                     = '*.*',
  $syslog_server_port               = '5544',

  $elasticsearch_class              = undef,
  $elasticsearch_config_template    = 'stack_logstash/elasticsearch.yml.erb',
  $elasticsearch_config_hash        = { },
  $elasticsearch_instances_hash     = { 'el01' => { ensure => present } },
  $elasticsearch_protocol           = 'http',
  $elasticsearch_server             = '',
  $elasticsearch_server_port        = '9200',
  $elasticsearch_cluster_name       = 'logs',
  $elasticsearch_java_heap_size     = '1024',
  $elasticsearch_version            = '1.0.1',

  $logstash_class                   = undef,
  $logstash_config_template         = 'stack_logstash/logstash.conf.erb',
  $logstash_config_hash             = { },

  $kibana_class                     = undef,
  $kibana_config_template           = undef,
  $kibana_config_hash               = { },

  $monitor_class                    = undef,
  $firewall_class                   = undef,

  ) {

  $repo_class_require = $repo_class ? {
    ''        => undef,
    default   => undef,
    # default   => "Class['${repo_class}']",
  }

  $real_elasticsearch_server = $elasticsearch_server ? {
    # query_nodes('Class[elasticsearch]{tags=stack_logstash}',ipaddress), #
    # TODO: Fix query
    ''      => query_nodes('Class[elasticsearch]',ipaddress),
    default => $elasticsearch_server,
  }

  if $repo_class {
    class { $repo_class: }
  }

  if $syslog_class {
    include $syslog_class
  }

  if $logstash_class {
    class { $logstash_class:
      require => $repo_class_require,
    }
  }

  if $elasticsearch_class {
    class { $elasticsearch_class:
      require => $repo_class_require,
    }
  }

  if $kibana_class {
    class { $kibana_class:
      require => $repo_class_require,
    }
  }

  if $monitor_class {
    include $monitor_class
  }

  if $firewall_class {
    include $firewall_class
  }

}
