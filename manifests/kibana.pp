class stack_logstash::kibana (
  $kibana_version = '3.1.1',
  ) {

  class { '::kibana':
    version           => $kibana_version,
#    elasticsearch_url => "${::stack_logstash::elasticsearch_protocol}://${::stack_logstash::real_elasticsearch_server}:${::stack_logstash::elasticsearch_server_port}",
    file_template     => $::stack_logstash::kibana_config_template,
#    webserver         => 'nginx',
  }

  if $::stack_logstash::kibana_webserver {
    tp::install { $::stack_logstash::kibana_webserver: }
    tp::conf { "${::stack_logstash::kibana_webserver}::conf.d/kibana.conf":
      template => $::stack_logstash::real_kibana_webserver_config_template,
    }
  }
}
