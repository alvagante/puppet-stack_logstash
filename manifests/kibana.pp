class stack_logstash::kibana (
  $version                   = '3.1.1',
  $kibana_url                = "kibana.${::domain}",
  $config_template           = undef,
  $options_hash              = { },
  $webserver                 = 'nginx',
  $webserver_config_template = undef,
  ) {

  $real_webserver_config_template = $webserver_config_template ? {
    undef    => "stack_logstash/kibana/kibana.conf-${webserver}",
    default  => $webserver_config_template,
  }
  class { '::kibana':
    version           => $kibana_version,
    file_template     => $config_template,
  }

  if $webserver
  and $webserver != '' {
    tp::install { $webserver: }
    tp::conf { "${webserver}::conf.d/kibana.conf":
      template => $real_webserver_config_template,
    }
  }
}
