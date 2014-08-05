# == Class: varnish::params
#

class varnish::params {
  # set Varnish conf location based on OS
  case $::operatingsystem {
    /(?i:Centos|RedHat|OracleLinux)/ : {
      if $::operatingsystemmajrelease >= 7 {
        $conf_use_systemd = true
        $params_file_path = '/etc/varnish/varnish.params'
        $conf_file_path = '/etc/systemd/system/varnish.service'
      } else {
        $conf_use_systemd = false
        $conf_file_path = '/etc/default/varnish'
      }
    }
    default : {
      $conf_use_systemd = false
      $conf_file_path = '/etc/default/varnish'
    }
  }

  $version = $varnish::version ? {
    /4\..*/ => 4,
    default => 3,
  } }
