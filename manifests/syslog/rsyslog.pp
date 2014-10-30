class stack_logstash::syslog::rsyslog {

  tp::install { 'rsyslog': }

  if $::stack_logstash::syslog_config_template {
    tp::conf { 'rsyslog::00_logstash.conf':
      template => $::stack_logstash::syslog_config_template,
    }
  }

}
