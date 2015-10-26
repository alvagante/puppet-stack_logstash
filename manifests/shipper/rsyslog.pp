class stack_logstash::shipper::rsyslog (
  $config_template           = 'stack_logstash/shipper/rsyslog.conf.erb',
  $options_hash              = { },
  $syslog_files              = '*.*',
  $version                   = '8',
  $use_adiscom_repo          = true,
) {

  # Rsyslog repo
  if $use_adiscom_repo == true {
    case $::operatingsystem {
      'RedHat': {
        yumrepo { "Adiscom Rsyslog v${version}-stable for CentOS-\$releasever-\$basearch":
          descr          => "Adiscom Rsyslog v${version}-stable for CentOS-\$releasever-\$basearch",
          baseurl        => "http://rpms.adiscon.com/v${version}-stable/epel-\$releasever/\$basearch",
          enabled        => 1,
          gpgcheck       => 0,
          protect        => 1,
          before         => Tp::Install3['rsyslog'],
        }
      }
      'Debian': {
        apt::source { "rsyslog-v${version}":
          location    => "http://debian.adiscon.com/v${version}-stable",
          repos       => ' ',
          release     => "${::lsbdistcodename}/",
          include_src => false,
          key         => '1362E120FE08D280780169DC894ECF17AEF0CF8E',
          before         => Tp::Install3['rsyslog'],
        }
      }
      'Ubuntu': {
        apt::ppa { "ppa:adiscon/v${version}-stable":
          before         => Tp::Install3['rsyslog'],
        }
      }
      default: {
      }
    }
  }

  tp::install3 { 'rsyslog': }

  if $config_template
  and $config_template != '' {
    tp::conf3 { 'rsyslog::00_logstash.conf':
      template => $config_template,
    }
  }

}
