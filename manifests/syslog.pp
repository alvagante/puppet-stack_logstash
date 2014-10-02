class stack_logstash::syslog {

  if $syslog_config_template {
    rsyslog::config { 'logstash_stack':
      content  => template($syslog_config_template),
    }
  }
  class { '::rsyslog':
    syslog_server => $syslog_server,
  }

}
