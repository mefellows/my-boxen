require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }


  # Matt's stuff
  include virtualbox
  include java
  include sublime_text_2
  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  # Export key bindings, user settings etc.
  # /Users/mfellows/Library/Application Suppport/Sublime Text 2/Packages/User/Package Control.sublime-settings"
  # /Users/mfellows/Library/Application Suppport/Sublime Text 2/Packages/User/.sublime-settings"

#  file { "${boxen::config::bindir}/subl":
#    ensure  => link,
#    target  => '/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl',
#    mode    => '0755',
#    require => Package['SublimeText2'],
#  }



# IDE
 class { 'intellij':
   edition => 'community',
 }


# Browsers
  include chrome
  include firefox

  # Vagrant
  include vagrant

  # Virtualbox
  include virtualbox

  # Dropbox
  include dropbox
  include evernote

  include hipchat

  # Packages installed via homebrew
  package {
    [
      'heroku-toolbelt',
      'rbenv-gem-rehash',
      'readline',
      'scala',
      'sbt',
      'ctags',
      'ruby-build'
    ]:
  }

  # OS Customizations
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::software_update
  include osx::no_network_dsstores

  boxen::osx_defaults { 'Disable autocorrect':
    ensure => present,
    domain => 'com.apple.driver.AppleBluetoothMultitouch.mouse',
    key    => 'MouseButtonMode',
    value  => 'TwoButton',
    user   => $::boxen_user;
  }

  class { 'osx::dock::icon_size':
    size => 26
  }

  # Add/remove applications to the Dock
  include dockutil

  dockutil::item { 'Add iTerm':
    item     => '/Applications/iTerm.app',
    label    => 'iTerm',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add MacVim':
    item     => '/Applications/MacVim.app',
    label    => 'MacVim',
    action   => 'add',
    position => 3,
  }

  dockutil::item { 'Remove Notes':
    item     => '/Applications/Notes.app',
    label    => 'Notes',
    action   => 'remove'
  }

  dockutil::item { 'Remove Photo Booth':
    item     => '/Applications/Photo Booth.app',
    label    => 'Photo Booth',
    action   => 'remove'
  }

  dockutil::item { 'Remove Mission Control':
    item     => '/Applications/Mission Control.app',
    label    => 'Mission Control',
    action   => 'remove'
  }

  dockutil::item { 'Remove Launchpad':
    item     => '/Applications/Launchpad.app',
    label    => 'Launchpad',
    action   => 'remove'
  }

  dockutil::item { 'Remove Contacts':
    item     => '/Applications/Contacts.app',
    label    => 'Contacts',
    action   => 'remove'
  }

  #### Additional Goodies

  # Spotify
  include spotify


  # Node modules

  ### Bower, yeoman, s8 ....



  #### Bash configuration, VIM defaults etc.

  #### AWS/etc. configuration/expoarts/keys etc.?

  #### SSH Keys and so on





  ### Keyboard/Mouse
  
  # Set default keyboard to Dvorak

  # Enable path view in Dock
  # defaults write com.apple.finder FXShowPosixPathInTitle -bool YES; killall Dock






}
