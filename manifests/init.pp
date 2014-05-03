class qmail (

  $defaultdelivery = $::qmail::params::defaultdelivery,
  $me              = $::qmail::params::me,
  $rcpthosts       = $::qmail::params::rcpthosts,
  $smtproutes      = $::qmail::params::smtproutes,
  $locals          = $::qmail::params::locals,
  $tcp_smtp        = $::qmail::params::tcp_smtp,

) inherits ::qmail::params {

  validate_string($defaultdelivery)
  validate_string($me)
  validate_array($rcpthosts)
  validate_array($smtproutes)
  validate_array($locals)
  validate_array($tcp_smtp)

  # N.B. Qmail package on Ubuntu adds qmail users in
  # the post install script.  Ubuntu is the only platform
  # currently supported.

  # Redhat platforms don't appear to provide packages
  # for Qmail thus Ubuntu the only platform we're supporting.

  package { 'qmail':
    ensure => installed,
  }

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['qmail'],
  }

  create_resources(file, {
    '/etc/qmail/defaultdelivery' => {
      content => "$defaultdelivery\n",
    }, '/etc/qmail/me' => {
      content => "$me\n",
    }, '/etc/qmail/rcpthosts' => {
      content => inline_template('<%= @rcpthosts.join("\n") + "\n" %>'),
    }, '/etc/qmail/smtproutes' => {
      content => inline_template('<%= @smtproutes.join("\n") + "\n" %>')
    }, '/etc/qmail/locals' => {
      content => inline_template('<%= @locals.join("\n") + "\n" %>')
    }, '/etc/qmail/tcp.smtp' => {
      content => inline_template('<%= @tcp_smtp.join("\n") + "\n" %>')
    },
  })

  exec { '/usr/bin/qmailctl cdb':
    refreshonly => true,
    subscribe   => File['/etc/qmail/tcp.smtp'],
  }
}
