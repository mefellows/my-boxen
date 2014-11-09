class projects::android {
  notify { 'Loading Android modules': }

  include android::sdk
  include android::tools
  include android::platform_tools
  # android::build_tools

  package { 'android-intel-HAXM':
    provider => 'pkgdmg',
    source => 'https://software.intel.com/sites/default/files/managed/68/45/haxm-macosx_r04.zip'
  }

  # For cordova / java
  $ant_version = "apache-ant-1.9.3"

  file { "/opt/${ant_version}/":
    ensure  => directory
  }

  archive { 'ant':
    ensure      => present,
    url         => "http://mirror.rackcentral.com.au/apache/ant/binaries/${ant_version}-bin.tar.gz",
    target      => "/opt/",
    checksum    => false,
    # Change src dir to speed things up after a restart?
    src_target  => '/opt/src/',
    timeout     => '300'
  }

  file { '/opt/bin/ant':
    ensure    => link,
    target    => "/opt/${ant_version}/bin/ant"
  }
}
