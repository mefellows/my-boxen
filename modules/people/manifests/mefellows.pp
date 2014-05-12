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
  include mongodb

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

    # "/Users/${::boxen_user}/development/public/scalam":
    #   source   => 'mefellows/scalam',
    #   provider => 'git';
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

  file { "/Users/${::boxen_user}/Library/Preferences/WebStorm6/keymaps/mfellows-keymap.xml":
    ensure    => file,
    source    => 'puppet:///modules/people/ide/mfellows-webstorm-keymap.xml',
    owner     => $::boxen_user,
    group     => 'staff'
  }

  file { "/Users/${::boxen_user}/Library/Preferences/WebStorm6/options/keymap.xml":
    ensure    => file,
    source    => 'puppet:///modules/people/ide/mfellows-webstorm-options-keymap.xml',
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
    ensure		=> file,
    source		=> 'puppet:///modules/people/sudoers',
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

  # Consider pkgdmg as provider?
  package { 'android-intel-HAXM':
    # provider => 'appdmg',
    provider => 'pkgdmg',
    source => 'https://software.intel.com/sites/default/files/managed/68/45/haxm-macosx_r04.zip'
  }

  package { 'unity-4.3.4':
    # provider => 'appdmg',
    provider => 'pkgdmg',
    source => 'http://netstorage.unity3d.com/unity/unity-4.3.4.dmg'
  }

}