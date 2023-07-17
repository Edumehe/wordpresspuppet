$document_root = '/home/vagrant'
$base_site = '/var/www/html'
$username = 'root'
$dbname = 'wordpress'
$dbuser = 'wordpressusr'
$wpadmin = 'wp_admin'
$password = 'passw0rd!'
$port = '8805'

exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

notify { "starting wordpress provisioning......": }


Exec { path => "/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin:/usr/local/sbin:~/.composer/vendor/bin/" }

notify {'Start install':
  message => "Installed packages with puppet:\n\nApache2\nPHP 8.1\nMySQL\nWordPress 6.2\nWP CLI",
  require => Exec['apt-update']
}

require apache2
require php8
require mysql
require wordpress
require wpcli

Exec { 'Clean files':
  command => "rm -Rf wordpress-6.2.tar.gz puppet7-release-jammy.deb create-db.sql wordpress",
  cwd => $document_root,
  require => Exec["Modify access Wordpress"]
}

notify {'Finished install':
  message => "The installation was completed.\n\n\nNow access on http://localhost:${port} with your web browser.",
  require => Notify['WP-CLI-Installed']
}
