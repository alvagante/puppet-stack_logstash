class stack::logs (

  $ensure                           = 'present',

  $monitor                          = false,
  $monitor_tool                     = 'puppi',

  $firewall                         = false,
  $firewall_tool                    = 'iptables',

  $syslog_server                    = false,
  $syslog_server_port               = '5544',
  $elasticsearch_server             = false,
  $elasticsearch_server_port        = '9200',

  $install_syslog_server            = false,
  $install_logstash                 = false,
  $install_elasticsearch            = false,
  $install_kibana                   = false,

  $install_graylog2                 = false,
  $install_graylog2_webinterface    = false,

  $syslog_config_template           = 'stack/logs/syslog.conf.erb',
  $logstash_config_template         = 'stack/logs/logstash.conf.erb',
  $elasticsearch_config_template    = 'stack/logs/elasticsearch.yml.erb',
  $kibana_config_template           = 'stack/logs/config.js.erb',
  $graylog2_config_template         = 'stack/logs/graylog2.conf.erb',

  ) {

  if $syslog_server
  or $install_syslog_server {
    if $syslog_config_template {
      rsyslog::config { 'logstash_stack':
        content  => template($syslog_config_template),
      }
    }
    class { 'rsyslog':
      syslog_server => $syslog_server,
      mode          => $graylog_syslog_run_mode,
      monitor       => $monitor,
      monitor_tool  => $monitor_tool,
      firewall      => $firewall,
      firewall_tool => $firewall_tool,
    }
  }

  if $install_logstash {
    class { 'logstash':
      run_mode      => $logstash_run_mode,
      create_user   => $user_create,
      template      => $logstash_config_template,
      monitor       => $monitor,
      monitor_tool  => $monitor_tool,
      firewall      => $firewall,
      firewall_tool => $firewall_tool,
    }
  }

  if $install_elasticsearch {
    class { 'elasticsearch':
      create_user   => $user_create,
      template      => $elasticsearch_config_template,
      monitor       => $monitor,
      monitor_tool  => $monitor_tool,
      firewall      => $firewall,
      firewall_tool => $firewall_tool,
    }
  }

  if $install_kibana {
    class { 'kibana':
      elasticsearch_url => "http://${elasticsearch_server}:${elasticsearch_server_port}",
      file_template     => $kibana_config_template,
      webserver         => 'apache',
    }
  }

  if $install_graylog2 {
    class { 'graylog2':
      install               => true,
      webinterface_install  => $install_graylog_webinterface,
      create_user           => $user_create,
      template              => $graylog2_config_template,
      monitor               => $monitor,
      monitor_tool          => $monitor_tool,
      firewall              => $firewall,
      firewall_tool         => $firewall_tool,
    }
  }

}
