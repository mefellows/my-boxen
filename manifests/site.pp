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
    '/opt/bin',
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

# For build artifacts to avoid re-downloading
file { '/opt/src':
  ensure  => directory,
  owner   => $boxen_user,
  group   => 'staff'
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
  include autoconf
  include pcre
  include libpng
  include wget

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # Node modules
  nodejs::module { ['cordova', 'ionic', 'ios-sim', 'ripple', 'grunt', 'generator-ionic', 'karma', 'karma-jasmine', 'express', 'bower', 'yeoman']:
    node_version => 'v0.10.26'
  }

  # Set the global default ruby (auto-installs it if it can)
  $ruby_version = '2.0.0-p451'
  class { 'ruby::global':
    version => $ruby_version
  }

  # Install other Rubies
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }

  ruby::gem { "compass for ruby ${ruby_version}":
    gem           => 'compass',
    version       => '~> 0.12.6',
    ruby          => $ruby_version,
  }

  # Setup alternative bin dir
  file { '/opt/bin':
    ensure  => directory,
    owner   => $boxen_user,
    group   => 'staff'
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }


  # include chrome # stable
  # include firefox # stable

  # Live on the edge, man!
  include firefox::beta
  include chrome::canary
  include virtualbox
  include java
  include sublime_text_2
  include iterm2::stable
  include vagrant
  include virtualbox
  include dropbox
  include evernote
  include hipchat
  include omnigraffle::pro
  include skype
  include spotify

  # Packages installed via homebrew
  package {
    [
      'heroku-toolbelt',
      'rbenv-gem-rehash',
      'readline',
      'scala',
      'sbt',
      'ctags',
      'ruby-build',
      'gnu-sed', # replace useless sed that comes with OSX
      'bash-completion',
    ]:
  }

  # Ruby Gems
  package { ['compass', 'puppet', 'librarian-puppet', 'sinatra']:
      ensure => present,
      provider => 'gem'
  }

  include projects::ide_sublime

  # IDE Setup
  include webstorm
  class { 'intellij':
   edition => 'community',
  }

  # Update plist to use Java 1.7
  exec { 'intellij-replace-required-jdk':
    command   => "sed -i.bak 's/1\.6\*/1\.7*/g' /Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist",
    unless    => "grep 1.7 /Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist"
  }
    # Update plist to use Java 1.7
  exec { 'webstorm-replace-required-jdk':
    command   => "sed -i.bak 's/1\.6\*/1\.7*/g' /Applications/WebStorm.app/Contents/Info.plist",
    unless    => "grep 1.7 /Applications/WebStorm.app/Contents/Info.plist"
  }

  # OS Customizations
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::software_update
  include osx::no_network_dsstores

  # Show the path bar

  osxutils::defaults { 'com.apple.finder':
    key     => 'ShowPathbar -bool',
    value   => true,
    user    => 'root'
  }

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

  # I like my dock clean and tidy please
  dockutil::item { 'Add Terminal':
    item     => '/Applications/iTerm.app',
    label    => 'iTerm',
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

  # Include project specific stuff
  include projects::web
  include projects::mit
}