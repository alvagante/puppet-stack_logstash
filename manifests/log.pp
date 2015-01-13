define stack_logstash::log (
  $log_path                  = $title,
  $log_type                  = 'syslog',
  $log_tags                  = '',
  $shipper_template          = '',
  $logstash_filter_template  = 'stack_logstash/logs/logstash.conf.erb',
  $kibana_dashboard_template = '',
  $options_hash              = { },
) {


}
