class projects::mit {

  notify { 'Hey, you\'re a Melbourne IT employee. Let me configure your work setup.': }

  # Consider pkgdmg as provider?
  package { 'RDC_2.1.1_ALL':
    provider => 'pkgdmg',
    source => 'http://download.microsoft.com/download/C/F/0/CF0AE39A-3307-4D39-9D50-58E699C91B2F/RDC_2.1.1_ALL.dmg'
  }

  package { 'lync_14.0.8_140321':
    provider => 'pkgdmg',
    source => 'http://download.microsoft.com/download/5/0/0/500C7E1F-3235-47D4-BC11-95A71A1BA3ED/lync_14.0.8_140321.dmg'
  }

  # Need to do this due to bug in Lync.
  # http://preston4tw.blogspot.com.au/2013/12/microsoft-lync-2011-for-mac-1407-bug.html
  file { '/Applications/Microsoft Lync.app/Contents/Frameworks/USBHidWrapper.framework':
    ensure      => link,
    target      => '/Applications/Microsoft Lync.app/Contents/Frameworks/USBHIDWrapper.framework/',
  }
}