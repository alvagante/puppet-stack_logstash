# Class stack::logstash
#
class stack::logstash (

  $syslog_install                   = false,
  $syslog_config_template           = 'stack/logstash/syslog.conf.erb',
  $syslog_config_hash               = { },
  $syslog_server                    = false,
  $syslog_files                     = '*.*',
  $syslog_server_port               = '5544',

  $elasticsearch_install            = false,
  $elasticsearch_config_template    = 'stack/logstash/elasticsearch.yml.erb',
  $elasticsearch_config_hash        = { },
  $elasticsearch_protocol           = 'http',
  $elasticsearch_server             = '',
  $elasticsearch_server_port        = '9200',
  $elasticsearch_cluster_name       = 'logs',
  $elasticsearch_java_heap_size     = '1024',
  $elasticsearch_version            = '1.0.1',

  $logstash_install                 = false,
  $logstash_config_template         = 'stack/logstash/logstash.conf.erb',
  $logstash_config_hash             = { },

  $kibana_install                   = false,
  $kibana_config_template           = undef,
  $kibana_config_hash               = { },

  $monitor_class                    = '::stack::logstash::monitor',
  $firewall_class                   = '::stack::logstash::firewall',

  ) {

  $real_elasticsearch_server = $elasticsearch_server ? {
    # query_nodes('Class[elasticsearch]{tags=stack::logstash}',ipaddress), #
    # TODO: Fix query
    ''      => query_nodes('Class[elasticsearch]',ipaddress),
    default => $elasticsearch_server,
  }

  if $syslog_server
  and $syslog_install {
    if $syslog_config_template {
      rsyslog::config { 'logstash_stack':
        content  => template($syslog_config_template),
      }
    }
    class { '::rsyslog':
      syslog_server => $syslog_server,
    }
  }

  if $logstash_install {
    class { '::logstash':
      run_mode      => $logstash_run_mode,
      create_user   => $user_create,
      template      => $logstash_config_template,
    }
  }

  if $elasticsearch_install {
    class { '::elasticsearch':
      create_user    => $user_create,
      version        => $elasticsearch_version,
      java_heap_size => $elasticsearch_java_heap_size,
      template       => $elasticsearch_config_template,
    }
  }

  if $kibana_install {
    class { '::kibana':
      elasticsearch_url => "${elasticsearch_protocol}://${elasticsearch_server}:${elasticsearch_server_port}",
      file_template     => $kibana_config_template,
      webserver         => 'apache',
    }
  }


  if $monitor_class {
    include $monitor_class
  }

  if $firewall_class {
    include $firewall_class
  }

}
