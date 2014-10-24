class stack_logstash::logstash {

  class { '::logstash':
    install_contrib => true,
  }

  logstash::configfile { 'main':
    content => template($::stack_logstash::logstash_config_template),
  }

}
