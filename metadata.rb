name             'wpapp'
maintainer       'Austin Heiman'
maintainer_email 'atheiman@ksu.edu'
license          'All rights reserved'
description      'Installs/Configures wordpress app to the point of the 5-minute wordpress config in the browser'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "apache2"
depends "mysql"
depends "php"
depends "database"
