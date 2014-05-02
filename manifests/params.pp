class qmail::params {
  if $::operatingsystem == 'ubuntu' {
    $locals          = ['localhost', $::fqdn]
    $defaultdelivery = './Maildir/'
    $me              = $::fqdn
    $rcpthosts       = ['localhost', $::fqdn]
    $smtproutes      = []
  }
  else {
    fail("Class['qmail::params']: Unsupported operatingsystem: ${::operatingsystem}")
  }
}
