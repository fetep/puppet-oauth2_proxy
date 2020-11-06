# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
class oauth2_proxy::params {
  $manage_user      = true
  $user             = 'oauth2'
  $manage_group     = true
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $service_template = 'oauth2_proxy@.service.erb'
  $manage_service   = true
  $provider         = 'systemd'

  $version  = '6.1.1'
  $tarball  = "oauth2-proxy-v${version}.linux-amd64.tar.gz"
  $source   = "https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v{version}/${tarball}"
  $checksum = '950766d81ed3817ab8e7a3680bbb4eeddf7bac9c'

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7 and fc33
  case $::osfamily {
    'RedHat': {
#      $provider = 'systemd'
      $shell = '/sbin/nologin'
      $systemd_path = '/usr/lib/systemd/system'
    }
    'Debian': {
#      $provider = 'debian'
      $shell = '/usr/sbin/nologin'
      $systemd_path = '/etc/systemd/system'
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${::operatingsystem}")
    }
  }

  # bit.ly does not provide x86 builds
  case $::architecture {
    'x86_64': {}
    'amd64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${::architecture}")
    }
  }
}
