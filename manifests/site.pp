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

  $HOME = "/Users/${::boxen_user}"

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
  include iterm2::stable

  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  sublime_text_2::package { 'Scalaformat':
    source => 'timonwong/ScalaFormat'
  }

  sublime_text_2::package { 'ScalaTest':
    source => 'patgannon/sublimetext-scalatest'
  }

  sublime_text_2::package { 'Git':
    source => 'timonwong/ScalaFormat'
  }

  sublime_text_2::package { 'Puppet':
    source => 'russCloak/SublimePuppet'
  }

  sublime_text_2::package { 'Puppet Syntax':
    source => 'Stubbs/sublime-puppet-syntax'
  }

  sublime_text_2::package { 'Git Gutter':
    source => 'jisaacks/GitGutter'
  }

  sublime_text_2::package { 'SideBar Gutter':
    source => 'SublimeText/SideBarGit'
  }

  sublime_text_2::package { 'Gist':
    source => 'condemil/Gist'
  }

  sublime_text_2::package { 'Compass':
    source => 'whatwedo/Sublime-Text-2-Compass-Build-System'
  }

  sublime_text_2::package { 'Sass':
    source => 'nathos/sass-textmate-bundle'
  }

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
  include omnigraffle
  include omnigraffle::pro
  include skype

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

  boxen::osx_defaults { 'Enable Secondary Click':
    ensure => present,
    domain => 'com.apple.driver.AppleBluetoothMultitouch.mouse',
    key    => 'MouseButtonMode',
    value  => 'TwoButton',
    user   => $::boxen_user;
  }

  class { 'osx::dock::icon_size':
    size => 36
  }

  # Add/remove applications to the Dock
  include dockutil

  dockutil::item { 'Add Terminal':
    item     => '/Applications/Utilities/Terminal.app',
    label    => 'Terminal',
    action   => 'add',
    position => 1,
  }

  dockutil::item { 'Add Sublime':
    item     => '/Applications/Sublime Text 2.app',
    label    => 'Sublime Text 2',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add Spotify':
    item     => '/Applications/Spotify.app',
    label    => 'Spotify',
    action   => 'add',
    position => 2,
  }
  dockutil::item { 'Add Firefox':
    item     => '/Applications/Firefox.app',
    label    => 'Firefox',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add Google Chrome':
    item     => '/Applications/Google Chrome.app',
    label    => 'Google Chrome',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add HipChat':
    item     => '/Applications/HipChat.app',
    label    => 'HipChat',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add Dropbox':
    item     => '/Applications/Dropbox.app',
    label    => 'Dropbox',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add Evernote':
    item     => '/Applications/Evernote.app',
    label    => 'Evernote',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add Intellij':
    item     => '/Applications/IntelliJ IDEA 13 CE.app',
    label    => 'IntelliJ IDEA 13 CE',
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
  # install some npm modules
  nodejs::module { 'grunt':
    node_version => 'v0.10.26'
  }

  nodejs::module { 'express':
    node_version => 'v0.10.26'
  }

  nodejs::module { 'bower':
    node_version => 'v0.10.26'
  }

  nodejs::module { 'yeoman':
    node_version => 'v0.10.26'
  }

  # nodejs::module { 'angular':
  #   node_version => 'v0.10.26'
  # }

  # nodejs::module { 'generator-scalatra':
  #   node_version => 'v0.10.26'
  # }
}