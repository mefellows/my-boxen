class projects::game {
  notify { 'Loading game modules': }
  package { 'unity-4.3.4':
    provider => 'pkgdmg',
    source => 'http://netstorage.unity3d.com/unity/unity-4.3.4.dmg'
  }
}