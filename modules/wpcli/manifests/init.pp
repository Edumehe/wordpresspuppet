class wpcli {
  file { 'Copy wp cli to enable commands':
    path => "/usr/local/bin/wp",
    ensure  => present,
    source => 'puppet:///modules/wpcli/wp-cli.phar',
    require => Exec['Move Wordpress directory'],
    owner => 'vagrant',
    group => 'vagrant',
    mode => "u+x"
  }

  #exec { 'Install Language spanish':
  #  command => "wp language core install es --allow-root --path='${base_site}'",
  #  require => File['Copy wp cli to enable commands']
  #}

  exec { 'Basic config':
    command => "wp core install --url=localhost:${port} --locale=es_SV --title='WordPress Inicio' --admin_name=${wpadmin} --admin_password=${password} --admin_email=laliuxmejia@gmail.com --allow-root --path='${base_site}'",
    require => File['Copy wp cli to enable commands'],
    notify => Service['apache2']
  }

  exec { 'Install theme':
    command => "wp theme install expound --allow-root --path='${base_site}' --activate",
    require => Exec['Basic config']
  }

  notify {'WP-CLI-Installed':
    message => "Module WP-CLI installed...",
    require => Exec['Install theme']
  }
}
