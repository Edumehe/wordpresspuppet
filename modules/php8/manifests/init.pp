class php8 {
  exec { "install_preview":
    command => "apt install ca-certificates apt-transport-https software-properties-common -y",
    #require => Exec["apt-update"]
  }

  exec { "add_source_repo":
    command => "add-apt-repository -y ppa:ondrej/php",
    require => Exec["install_preview"]
  }

  #exec { "install_php":
  #  command => "apt install php8.1 -y",
  #  require => Package["add_source_repo"],
  #  notify => Service['apache2']
  #}

    package { 'php8.1':
      ensure => installed,
      require => Exec["add_source_repo"]      
    }

    exec { 'php_extensions':
      command => 'apt install php8.1-cli php8.1-fpm php8.1-common php8.1-imap php8.1-redis php8.1-xml php8.1-zip php8.1-mbstring php8.1-mysql -y',
      require => Package['php8.1']
    }

    exec { 'enable_php':
      command => "a2enmod proxy_fcgi setenvif && a2enconf php8.1-fpm && a2enmod php8.1",
      require => Exec['php_extensions'],
      notify => Service['apache2']
    }

  notify {'PHP-Installed':
    message => "Module PHP 8.1 installed...",
    require => Exec['enable_php']
  }
}
