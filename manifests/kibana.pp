class stack_logstash::kibana (
  $version                   = '4.4.2',
  $kibana_url                = "kibana.${::domain}",
  $config_template           = undef,
  $options_hash              = { },
  $webserver                 = 'nginx',
  $webserver_main_template   = '',
  $webserver_config_template = undef,
  ) {

  $default_options = {
    'elasticsearch'          => 'http://"+window.location.hostname+":9200',
    'default_route'          => '/dashboard/file/logstash.json',
    'kibana_index'           => 'kibana-int',
    'panel_names'            => "[ 'histogram','map','goal','table','filtering','timepicker','next','hits','column','trends','bettermap','query','terms','stats','sparklines' ]",
  }
  $options=merge($default_options , $options_hash)

  # TODO Install Kibana via TP
  $real_webserver_config_template = $webserver_config_template ? {
    undef    => "stack_logstash/kibana/kibana.conf-${webserver}",
    default  => $webserver_config_template,
  }
  tp::install3 { 'kibana': }
  if $config_template { 
    tp::conf3 { 'kibana':
      template     => $config_template,
      options_hash => $options,
    }
  }

  if $webserver
  and $webserver != '' {
    tp::install3 { $webserver: }
    tp::conf3 { "${webserver}::conf.d/kibana.conf":
      template     => $real_webserver_config_template,
      options_hash => $options,
    }
    if $webserver_main_template != '' { 
      tp::conf3 { $webserver:
        template     => $webserver_main_template,
        options_hash => $options,
      }
    }
  }

}
