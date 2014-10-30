# Class stack_logstash::repo
#
# This class manages yum and apt repos for RedHat and Debian osfamily
# It installs the upstream repositories
# The apt setup requires PuppetLabs' apt module
#
class stack_logstash::repo (
  $rsyslog_version       = '8',
  $elasticsearch_version = '1.3',
  $logstash_version      = '1.4',
  ) {

  # Rsyslog repo
  if $::stack_logstash::syslog_class == '::stack_logstash::syslog::rsyslog' {
    case $::operatingsystem {
      'RedHat': {
         yumrepo { "Adiscom Rsyslog v${rsyslog_version}-stable for CentOS-\$releasever-\$basearch":
           descr          => "Adiscom Rsyslog v${rsyslog_version}-stable for CentOS-\$releasever-\$basearch",
           baseurl        => "http://rpms.adiscon.com/v${rsyslog_version}-stable/epel-\$releasever/\$basearch",
           enabled        => 1,
           gpgcheck       => 0,
           protect        => 1,
         }
      }
      'Debian': {
        apt::source { "rsyslog-v${rsyslog_version}":
          location    => "http://debian.adiscon.com/v${rsyslog_version}-stable",
          repos       => ' ',
          release     => "${::lsbdistcodename}/",
          include_src => false,
          key         => 'AEF0CF8E',
        }
      }
      'Ubuntu': {
        apt::ppa { "ppa:adiscon/v${rsyslog_version}-stable": }
      }
      default: {
      }
    }
  }


  # Keys for ElasticSearch and Logstash
  if $::stack_logstash::elasticsearch_class
  or $::stack_logstash::logstash_class {
    # Elasticsearch keys
    case $::osfamily {
      'RedHat': {
         exec { "rpmkey_add_elasticsearch":
           command     => 'rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
           refreshonly => true,
           path        => '/sbin:/bin:/usr/sbin:/usr/bin',
         }
      }
      'Debian': {
        apt::key { "elasticsearch":
          key         => 'D88E42B4',
          key_source  => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
        }
      }
      default: {
      }
    }
  }

  # Elasticsearch repo
  if $::stack_logstash::elasticsearch_class {
    case $::osfamily {
      'RedHat': {
         yumrepo { "elasticsearch-${elasticsearch_version}":
           descr          => "Elasticsearch repository for ${elasticsearch_version}.x packages",
           baseurl        => "http://packages.elasticsearch.org/elasticsearch/${elasticsearch_version}/centos",
           enabled        => 1,
           gpgcheck       => 1,
           gpgkey         => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
           notify         => Exec['rpmkey_add_elasticsearch'],
         }
      }
  
      'Debian': {
        apt::source { "elasticsearch-${elasticsearch_version}":
          location    => "http://packages.elasticsearch.org/elasticsearch/${elasticsearch_version}/debian",
          repos       => 'main',
          release     => 'stable',
          include_src => false,
        }
      }
  
      default: {
      }
    }
  }


  # Logstash repo
  if $::stack_logstash::logstash_class {
    case $::osfamily {
      'RedHat': {
         yumrepo { "logstash-${logstash_version}":
           descr          => "Logstash repository for ${logstash_version}.x packages",
           baseurl        => "http://packages.elasticsearch.org/logstash/${logstash_version}/centos",
           enabled        => 1,
           gpgcheck       => 1,
           gpgkey         => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
           notify         => Exec['rpmkey_add_elasticsearch'],
         }
      }

      'Debian': {
        apt::source { "logstash-${logstash_version}":
          location    => "http://packages.elasticsearch.org/logstash/${logstash_version}/debian",
          repos       => 'main',
          release     => 'stable',
          include_src => false,
        }
      }

      default: {
      }
    }
  }

}
