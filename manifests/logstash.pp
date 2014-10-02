class stack_logstash::logstash {

  class { '::logstash':
    run_mode      => $logstash_run_mode,
    create_user   => $user_create,
    template      => $logstash_config_template,
  }

}
