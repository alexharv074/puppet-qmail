class qmail (

  $locals          = $::qmail::params::locals,
  $defaultdelivery = $::qmail::params::defaultdelivery,
  $me              = $::qmail::params::me,
  $rcpthosts       = $::qmail::params::rcpthosts,
  $smtproutes      = $::qmail::params::smtproutes,

) inherits ::qmail::params {

  package { 'qmail':
    ensure => installed,
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['qmail'],
  }

  file { '/etc/qmail/defaultdelivery':
    ensure  => file,
    content => "$defaultdelivery\n",
  }

  file { '/etc/qmail/me':
    ensure  => file,
    content => "$me\n",
  }

  file { '/etc/qmail/rcpthosts':
    ensure  => file,
    content => inline_template('<%= @rcpthosts.join("\n") %>
'),
  }

  file { '/etc/qmail/smtproutes':
    ensure  => file,
    content => inline_template('<%= @smtproutes.join("\n") %>
'),
  }

  file { '/etc/qmail/locals':
    ensure  => file,
    content => inline_template('<%= @locals.join("\n") %>
'),
  }
}
