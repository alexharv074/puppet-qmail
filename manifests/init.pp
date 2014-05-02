class qmail (

  $defaultdelivery = $::qmail::params::defaultdelivery,
  $me              = $::qmail::params::me,
  $rcpthosts       = $::qmail::params::rcpthosts,
  $smtproutes      = $::qmail::params::smtproutes,
  $locals          = $::qmail::params::locals,

) inherits ::qmail::params {

  validate_array($rcpthosts)
  validate_array($smtproutes)
  validate_array($locals)

  # N.B. Qmail package on Ubuntu adds qmail users in
  # the post install script.  Ubuntu is the only platform
  # currently supported.

  package { 'qmail':
    ensure => installed,
  }

  $defaultdelivery_content = "$defaultdelivery\n"
  $me_content              = "$me\n"

  $rcpthosts_content  = inline_template('<%= @rcpthosts.join("\n")  + "\n" %>')
  $smtproutes_content = inline_template('<%= @smtproutes.join("\n") + "\n" %>')
  $locals_content     = inline_template('<%= @locals.join("\n")     + "\n" %>')

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['qmail'],
  }

  file { '/etc/qmail/defaultdelivery':
    ensure  => file,
    content => $defaultdelivery_content,
  }

  file { '/etc/qmail/me':
    ensure  => file,
    content => $me_content,
  }

  file { '/etc/qmail/rcpthosts':
    ensure  => file,
    content => $rcpthosts_content,
  }

  file { '/etc/qmail/smtproutes':
    ensure  => file,
    content => $smtproutes_content,
  }

  file { '/etc/qmail/locals':
    ensure  => file,
    content => $locals_content,
  }

}
