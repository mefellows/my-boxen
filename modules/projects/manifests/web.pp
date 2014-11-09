class projects::web {
  notify { 'Loading Web projects yo': }

  # Node modules
  nodejs::module { ['generator-angular', 'cordova', 'ionic', 'ios-sim', 'ripple', 'grunt', 'generator-ionic', 'karma', 'karma-jasmine', 'express', 'bower', 'yeoman']:
    node_version => 'v0.10.26'
  }

  include mysql
}
