class apache2 {
  package { 'apache2':
    ensure => installed,
  }

  file { 'Remove file 000-default':
    path => '/etc/apache2/sites-enabled/000-default.conf',
    ensure => absent,
    require => Package['apache2'],
  }

  file { 'Replace with virtual host erb':
    path => '/etc/apache2/sites-available/vagrant.conf',
    content => template('apache2/virtual-hosts.conf.erb'),
    require => File['Remove file 000-default'],
  }

  file { "Link vagrant conf from sites-enabled":
    path => '/etc/apache2/sites-enabled/vagrant.conf',
    ensure  => link,
    target  => "/etc/apache2/sites-available/vagrant.conf",
    require => File['Replace with virtual host erb'],
    notify  => Service['apache2'],
  }

  file { 'Remove file index':
    path => "${base_site}/index.html",
    ensure => absent,
    require => File['Link vagrant conf from sites-enabled'],
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }

  notify {'Apache2-Installed':
    message => "Module apache2 installed...",
    require => File['Remove file index']
  }
}
