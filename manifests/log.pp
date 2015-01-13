define stack_logstash::log (
  $log_path          = $title,
  $rsyslog_template  = 'stack_logstash/logs/rsyslog.conf.erb',
  $logstash_template = 'stack_logstash/logs/logstash.conf.erb',
  $options_hash      = { },
) {


}
