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
  class { 'nodejs::global': version => 'v0.10.26' }

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
  ruby::version { '2.1.2': }

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
  include chrome::beta
  include java
  include iterm2::stable

  class { 'vagrant':
    version => '1.6.5'
  }

  class { 'virtualbox':
    version     => '4.3.16',
    patch_level => '95972'
  }

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
  package { ['compass', 'puppet', 'librarian-puppet', 'sinatra', 'travis', 'jekyll']:
      ensure => present,
      provider => 'gem'
  }

  # Include project specific stuff
  include projects::web
  include projects::mac_preferences
  #include projects::android
  #include projects::game
  #include projects::mit
}