class stack_logstash::elasticsearch (
  $config_template    = 'stack_logstash/elasticsearch/elasticsearch.yml.erb',
  $options_hash       = { },
) {

  tp::install { 'elasticsearch': }

  if $config_template
  and $config_template != '' {
    tp::conf { 'elasticsearch':
      template => $config_template,
    }
  }
}
