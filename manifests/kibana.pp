class stack_logstash::kibana {

  class { '::kibana':
    elasticsearch_url => "${elasticsearch_protocol}://${elasticsearch_server}:${elasticsearch_server_port}",
    file_template     => $kibana_config_template,
    webserver         => 'apache',
  }

}
