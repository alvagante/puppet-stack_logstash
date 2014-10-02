class stack_logstash::elasticsearch {

  class { '::elasticsearch':
    create_user    => $user_create,
    version        => $elasticsearch_version,
    java_heap_size => $elasticsearch_java_heap_size,
    template       => $elasticsearch_config_template,
  }

}
