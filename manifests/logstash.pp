class stack_logstash::logstash (
  $config_template   = 'stack_logstash/logstash/logstash.conf.erb',
  $options_hash      = { },
) {

  tp::install3 { 'logstash': }

  if $config_template
  and $config_template != '' {
    tp::conf3 { 'logstash':
      template => $config_template,
    }
  }

}
