class people::mefellows {

  notify { 'Hello Matt, I\'m installing your shit...': }

  #### Bash configuration, VIM defaults etc.
  include 'boxen_private'

  # Development Workspace
  file { "${HOME}/development/": 
    ensure => directory
  }

  # Install my onegeek projects to begin with
  # include projects::onegeek

}