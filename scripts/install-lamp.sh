#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install LAMP stack (Apache, MariaDB, PHP)
# - Configure Apache for PHP
# - Install phpMyAdmin and WordPress test setup
##################################################################################################################################

main() {

    log_section "Installing LAMP stack"

    ############################################################################################################
    # Clean previous installation
    ############################################################################################################

    remove_matching_packages_deps php apache php-apache phpmyadmin mariadb
    disable_service httpd || true
    disable_service mariadb || true

    sudo rm -rf /srv/http/*
    sudo rm -rf /var/lib/mysql
    sudo rm -f /etc/httpd/conf/httpd.conf
    sudo rm -f /etc/php/php.ini
    sudo rm -f /etc/httpd/conf/extra/phpmyadmin.conf
    sudo rm -f /etc/httpd/conf/extra/httpd-wordpress.conf

    ############################################################################################################
    # Install packages
    ############################################################################################################

    install_packages apache php php-apache mariadb phpmyadmin

    enable_now_service httpd
    enable_now_service mariadb

    ############################################################################################################
    # Initialize MariaDB
    ############################################################################################################

    log_subsection "Initializing MariaDB"

    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo systemctl restart mariadb

    echo
    log_warn "Run the MariaDB secure setup now"
    sudo mariadb-secure-installation

    ############################################################################################################
    # Apache configuration
    ############################################################################################################

    log_subsection "Configuring Apache for PHP"

    sudo sed -i 's|LoadModule mpm_event_module|#LoadModule mpm_event_module|' /etc/httpd/conf/httpd.conf
    sudo sed -i 's|#LoadModule mpm_prefork_module|LoadModule mpm_prefork_module|' /etc/httpd/conf/httpd.conf

    if ! grep -q "php_module" /etc/httpd/conf/httpd.conf; then
        echo "LoadModule php_module modules/libphp.so
AddHandler php-script php
Include conf/extra/php_module.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
    fi

    sudo sed -i 's|#LoadModule rewrite_module|LoadModule rewrite_module|' /etc/httpd/conf/httpd.conf
    sudo sed -i 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|' /etc/httpd/conf/httpd.conf

    ############################################################################################################
    # PHP configuration
    ############################################################################################################

    log_subsection "Enabling PHP modules"

    sudo sed -i 's|;extension=mysqli|extension=mysqli|' /etc/php/php.ini
    sudo sed -i 's|;extension=pdo_mysql|extension=pdo_mysql|' /etc/php/php.ini
    sudo sed -i 's|;extension=iconv|extension=iconv|' /etc/php/php.ini

    ############################################################################################################
    # phpMyAdmin
    ############################################################################################################

    log_subsection "Configuring phpMyAdmin"

    sudo tee /etc/httpd/conf/extra/phpmyadmin.conf >/dev/null <<EOF
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
EOF

    grep -q "phpmyadmin.conf" /etc/httpd/conf/httpd.conf || \
        echo "Include conf/extra/phpmyadmin.conf" | sudo tee -a /etc/httpd/conf/httpd.conf

    ############################################################################################################
    # WordPress test
    ############################################################################################################

    log_subsection "Creating WordPress test environment"

    sudo mkdir -p /srv/http/wordpress

    sudo tee /etc/httpd/conf/extra/httpd-wordpress.conf >/dev/null <<EOF
Alias /wordpress "/usr/share/webapps/wordpress"
<Directory "/usr/share/webapps/wordpress">
  AllowOverride All
  Options FollowSymlinks
  Require all granted
</Directory>
EOF

    grep -q "httpd-wordpress.conf" /etc/httpd/conf/httpd.conf || \
        echo "Include conf/extra/httpd-wordpress.conf" | sudo tee -a /etc/httpd/conf/httpd.conf

    ############################################################################################################
    # Test pages
    ############################################################################################################

    log_subsection "Creating test pages"

    echo "<?php phpinfo(); ?>" | sudo tee /srv/http/index.php >/dev/null
    echo "<?php phpinfo(); ?>" | sudo tee /srv/http/wordpress/index.php >/dev/null

    ############################################################################################################

    sudo systemctl restart httpd
    sudo systemctl restart mariadb

    log_success "LAMP stack installed"

}

main "$@"