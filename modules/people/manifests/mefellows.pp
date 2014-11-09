class people::mefellows {

  notify { 'Hello Matt, I\'m installing your shit...': }

  #### Bash configuration, VIM defaults etc.

  file { "/Users/${::boxen_user}/dotfiles":
    ensure       => directory,
    recurse      => true,
    source       => ['puppet:///modules/people/dotfiles'],
    sourceselect  => all
  }

  file { "/Users/${::boxen_user}/.vimrc":
    source       => 'puppet:///modules/people/.vimrc'
  }

  file { "/Users/${::boxen_user}/.inputrc":
    source       => 'puppet:///modules/people/.inputrc'
  }

  file { "/Users/${::boxen_user}/.node-version":
    source       => 'puppet:///modules/people/.node-version'
  }

  file { "/Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist":
    ensure       => file,
    source       => 'puppet:///modules/people/terminal.settings.terminal'
  }

  # Office
  package { 'libreoffice':
    provider => 'pkgdmg',
    source => 'http://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/4.1.6/mac/x86/LibreOffice_4.1.6_MacOS_x86.dmg'
  }
  # package { 'libreoffice-en':
  #   provider => 'pkgdmg',
  #   source => 'http://download.documentfoundation.org/libreoffice/stable/4.2.4/mac/x86/LibreOffice_4.2.4_MacOS_x86_langpack_en-GB.dmg'
  # }


  # SSH / API keys etc.
  include 'boxen_private'

  # Development Workspace
  file { "${HOME}/development/":
    ensure => directory
  }

  file { "/Users/${::boxen_user}/.profile":
  	ensure => file,
  	source => 'puppet:///modules/people/.profile'
  }

  # IRC Client
  file { "/Users/${::boxen_user}/.irssi":
    ensure => directory
  }

  file { "/Users/${::boxen_user}/.irssi/config":
    ensure => file,
    source => 'puppet:///modules/people/.irssi.config'
  }

  # Install Scala plugin
  $intellij_plugin_dir = "/Users/${::boxen_user}/Library/Application\ Support/IdeaIC13"
  $intellij_plugin_dir2 = "/Users/${::boxen_user}/Library/Application Support/IdeaIC13"

  file { $intellij_plugin_dir2:
    ensure  => directory,
    owner   => $::boxen_user,
    group   => 'staff'
  }

  archive { 'intellij-scala-plugin':
    ensure      => present,
    url         => 'http://plugins.jetbrains.com/files/1347/15875/scala-intellij-bin-0.35.683.zip',
    checksum    => false,
    target      => "${intellij_plugin_dir}",

    # Change src dir to speed things up after a restart?
    src_target  => '/opt/src',
    timeout     => '300'
  }

  # Databases
  include mongodb
  include postgresql

  # Install my OSS projects to begin with
  repository {
    "/Users/${::boxen_user}/development/public/life-metrics":
      source   => 'mefellows/life-metrics', #short hand for github repos
      provider => 'git';

    "/Users/${::boxen_user}/development/public/cloudspec":
      source   => 'mefellows/cloudspec',
      provider => 'git';

    "/Users/${::boxen_user}/development/public/scalam-generator":
      source   => 'mefellows/scalam-generator',
      provider => 'git';

    "/Users/${::boxen_user}/development/public/generator-ionic":
      source   => 'mefellows/generator-ionic',
      provider => 'git';

    "/Users/${::boxen_user}/development/public/sitemap-generator":
      source   => 'mefellows/sitemap-generator',
      provider => 'git';
  }

  # Export key bindings, user settings etc. for Jetbrains IDE

  file { "/Users/${::boxen_user}/Library/Preferences/IdeaIC13/keymaps/mfellows-keymap.xml":
    ensure    => file,
    source    => 'puppet:///modules/people/ide/mfellows-jetbrains-keymap.xml',
    owner     => $::boxen_user,
    group     => 'staff'
  }

  file { "/Users/${::boxen_user}/Library/Preferences/IdeaIC13/options/keymap.xml":
    ensure    => file,
    source    => 'puppet:///modules/people/ide/mfellows-jetbrains-options-keymap.xml',
    owner     => $::boxen_user,
    group     => 'staff'
  }

  file { "/Users/${::boxen_user}/Library/Preferences/RubyMine60/keymaps/mfellows-keymap.xml":
    ensure    => file,
    source    => 'puppet:///modules/people/ide/mfellows-rubymine-keymap.xml',
    owner     => $::boxen_user,
    group     => 'staff'
  }

  # Export key bindings, user settings etc. for Sublime IDE
  file { [ "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages/User/"]:
    ensure    => directory
  }

  file { "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings":
    ensure    => file,
    source    => 'puppet:///modules/people/Preferences.sublime-settings'
  }

  # Root access baby!
  file { '/etc/sudoers':
    ensure    => file,
    source    => 'puppet:///modules/people/sudoers',
    owner     => 'root',
    group     => 'wheel'
  }

  # Coz VPN sucks!
  file { '/etc/hosts':
    ensure		=> file,
    source		=> 'puppet:///modules/people/hosts',
    owner     => 'root',
    group     => 'wheel'
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

  #
  # Game Dev
  #
  include android::sdk
  include android::tools
  include android::platform_tools
  # android::build_tools

  package { 'android-intel-HAXM':
    provider => 'pkgdmg',
    source => 'https://software.intel.com/sites/default/files/managed/68/45/haxm-macosx_r04.zip'
  }

  package { 'unity-4.3.4':
    provider => 'pkgdmg',
    source => 'http://netstorage.unity3d.com/unity/unity-4.3.4.dmg'
  }

  # package { 'mactex':
  #   provider => 'pkgdmg',
  #   source => 'http://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg'
  # }

# Installs VirtualBox
#
# Usage:
#
#   include virtualbox

  exec { 'Kill Virtual Box Processes':
    command     => 'pkill "VBoxXPCOMIPCD" || true && pkill "VBoxSVC" || true && pkill "VBoxHeadless" || true',
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }


  # Copy images into "/Users/mfellows/VirtualBox VMs"
  # TODO: Look this value up automatically

  archive::download { "windows-11":
    ensure        => present,
    url           => "http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz",
    checksum      => false
    src_target    => "/Users/${::boxen_user}/VirtualBox\ VMs",
  }



  package { 'VirtualBox-4.3.8-92456':
    ensure   => installed,
    provider => 'pkgdmg',
    source   => 'http://download.virtualbox.org/virtualbox/4.3.8/VirtualBox-4.3.8-92456-OSX.dmg',
    require  => Exec['Kill Virtual Box Processes'],
  }
}




curl -O -L "https://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE11-Win8.1&parts=4&filename=VMBuild_20140402/VirtualBox/IE11_Win8.1/Mac/IE11.Win8.1.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}"






}