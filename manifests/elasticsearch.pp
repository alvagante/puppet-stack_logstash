class stack_logstash::elasticsearch (
  $config_template    = 'stack_logstash/elasticsearch/elasticsearch.yml.erb',
  $options_hash       = { },
) {

  $default_options = {
    'network.host'           => $::ipaddress,
    'http.port'              => $::stack_logstash::elasticsearch_server_port,
    'http.cors.enabled'      => 'true',
  }
  $options=merge($default_options , $options_hash)

  tp::install { 'elasticsearch': }

  if $config_template
  and $config_template != '' {
    tp::conf { 'elasticsearch':
      template     => $config_template,
      options_hash => $options,
      require      => Tp::Install['elasticsearch'],
    }
  }
}
