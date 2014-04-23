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


  # Install my OSS projects to begin with
  repository {
    "/Users/${::boxen_user}/development/public/life-metrics":
      source   => 'mfellows/life-metrics', #short hand for github repos
      provider => 'git';

    "/Users/${::boxen_user}/development/public/cloudspec":
      source   => 'mfellows/cloudspec',
      provider => 'git',
  }


  # Export key bindings, user settings etc.

  file { [ "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages/User/"]:
    ensure		=> directory
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

}