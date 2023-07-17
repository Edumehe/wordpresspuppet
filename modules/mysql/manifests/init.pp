class mysql {
  notify { "MySQL installation....": }
  $enhancers = [ 'mysql-server', 'libapache2-mod-php8.1', 'php-mysql' ]
  package { $enhancers:
    ensure => installed,
    notify => Service['apache2']
  }

  service { 'Ensure mysql service is running and enable':
    name => 'mysql',
    ensure  => true,
    enable  => true,
    require => Package[$enhancers],
    restart => "/usr/sbin/service mysql reload"
  }

  exec { "set-mysql-password":
    unless => "mysqladmin -u ${username} -p ${password} status",
    command => "mysqladmin -u ${username} password ${password}",
    require => Service["Ensure mysql service is running and enable"]
  }

  file { 'Copy file exec': 
    path => "${document_root}/create-db.sql",
    ensure  => present,
    content => template('mysql/create-db.sql.erb'),
    #source => 'puppet:///modules/mysql/create-db.sql',
    require => Exec['set-mysql-password']
  }

  exec { 'Run MySQL command from file':
    command => "mysql -h localhost -u ${username} -D mysql < ${document_root}/create-db.sql",
    require => File["Copy file exec"]
  }

  notify {'MySQL-Installed':
    message => "Module mysql installed...",
    require => Exec['Run MySQL command from file']
  }
}
