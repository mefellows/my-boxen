class projects::ide {
  notify { 'Installing IDE\'s': }

  # IDE Setup
  class { 'webstorm':
      version => '8.0.4'
  }

  #include phpstorm

  class { 'rubymine':
      version => '6.3.3'
  }
  class { 'intellij':
   edition => 'community',
   version => '13.1.4b'
  }

  # Update plist to use Java 1.7
  exec { 'intellij-replace-required-jdk':
    command   => "sed -i.bak 's/1\.6\*/1\.7*/g' /Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist",
    unless    => "grep 1.7 /Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist"
  }

  # Update plist to use Java 1.7
  exec { 'rubymine-replace-required-jdk':
    command   => "sed -i.bak 's/1\.6\*/1\.7*/g' /Applications/RubyMine.app/Contents/Info.plist",
    unless    => "grep 1.7 /Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist"
  }

  # Update plist to use Java 1.7
  exec { 'webstorm-replace-required-jdk':
    command   => "sed -i.bak 's/1\.6\*/1\.7*/g' /Applications/WebStorm.app/Contents/Info.plist",
    unless    => "grep 1.7 /Applications/WebStorm.app/Contents/Info.plist"
  }

}