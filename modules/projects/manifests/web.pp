class projects::web {
  notify { 'Loading Web projects yo': }

  # PHP / Zend Setup
  # include php::5_3_8
  # Install a php version and set as the global default php
  # class { 'php::global':
  #   version => '5.3.8'
  # }

  include mysql

  ## Apache
  ## PHP, Composer, Zend?...
  # Install Composer globally on your PATH
  # include php::composer


  # Composer: https://getcomposer.org/doc/00-intro.md#globally-on-osx-via-homebrew-
  # homebrew::tap { 'josegonzalez/homebrew-php': }
  # homebrew::tap { 'homebrew/versions': }
  # homebrew::tap { '': }

  # package {
  #   'josegonzalez/php/composer':
  #     ensure => present
  # }

  ## MySQL
  ## PHP Storm
  include phpstorm

  # Node / Express



  # Install projects
  # Pull Down GitHub Repos -> create plugin to look at GitHub API based on 'group' and pull down repos in group?
  # mit-puppet
  # site-cocoon
  # site-renew
  # site-melbourneit
  # libmit

}
