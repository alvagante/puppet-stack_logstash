class stack_logstash::syslog::rsyslog (
  $config_template           = 'stack_logstash/syslog/rsyslog.conf.erb',
  $options_hash              = { },
  $syslog_files              = '*.*',
) {

  tp::install { 'rsyslog': }

  if $config_template
  and $config_template != '' {
    tp::conf { 'rsyslog::00_logstash.conf':
      template => $config_template,
    }
  }

}
