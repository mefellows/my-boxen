class projects::ide_sublime {
  notify { 'Loading Sublime + Plugins': }

  include sublime_text_2

  # sublime plugins
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
}