class projects::mac_preferences {
  notify { 'Setting up your Mac Preferences': }

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

  dockutil::item { 'Add Mailbox':
    item     => 'cd /Applications/Mailbox\ \(Beta\).app/',
    label    => 'Mailbox',
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

  dockutil::item { 'Remove Mail':
    item     => '/Applications/Mail.app',
    label    => 'Mail',
    action   => 'remove'
  }

  dockutil::item { 'Remove Safari':
    item     => '/Applications/Safari.app',
    label    => 'Safari',
    action   => 'remove'
  }

  dockutil::item { 'Remove Maps':
    item     => '/Applications/Maps.app',
    label    => 'Maps',
    action   => 'remove'
  }

  dockutil::item { 'Remove iTunes':
    item     => '/Applications/iTunes.app',
    label    => 'iTunes',
    action   => 'remove'
  }

  dockutil::item { 'Remove iBooks':
    item     => '/Applications/iBooks.app',
    label    => 'iBooks',
    action   => 'remove'
  }
}
