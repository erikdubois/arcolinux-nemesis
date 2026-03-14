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
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install LAMP stack (Apache, MariaDB, PHP)
# - Configure Apache for PHP
# - Install phpMyAdmin
# - Optionally expose Arch's wordpress package under /wordpress
#
# Notes
# - No destructive package removals
# - No wiping /srv/http or /var/lib/mysql
# - Reuses helpers from common.sh where already available
##################################################################################################################################

PHPMYADMIN_CONF="/etc/httpd/conf/extra/phpmyadmin.conf"
WORDPRESS_CONF="/etc/httpd/conf/extra/httpd-wordpress.conf"
HTTPD_CONF="/etc/httpd/conf/httpd.conf"
PHP_INI="/etc/php/php.ini"
DOCROOT="/srv/http"

append_if_missing() {
    local line="$1"
    local file="$2"

    if ! grep -Fqx "$line" "$file"; then
        echo "$line" | sudo tee -a "$file" >/dev/null
    fi
}

replace_or_append() {
    local pattern="$1"
    local replacement="$2"
    local file="$3"

    if grep -Eq "$pattern" "$file"; then
        sudo sed -i -E "s|$pattern|$replacement|" "$file"
    else
        echo "$replacement" | sudo tee -a "$file" >/dev/null
    fi
}

uncomment_ini_extension() {
    local extension="$1"
    local file="$2"

    sudo sed -i -E "s|^[;[:space:]]*extension[[:space:]]*=[[:space:]]*${extension}$|extension=${extension}|" "$file"
}

configure_apache_for_php() {
    log_subsection "Configuring Apache for PHP"

    sudo sed -i \
        -e 's|^LoadModule mpm_event_module modules/mod_mpm_event.so$|#LoadModule mpm_event_module modules/mod_mpm_event.so|' \
        -e 's|^#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so$|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|' \
        -e 's|^#LoadModule rewrite_module modules/mod_rewrite.so$|LoadModule rewrite_module modules/mod_rewrite.so|' \
        -e 's|^DirectoryIndex index.html$|DirectoryIndex index.php index.html|' \
        /etc/httpd/conf/httpd.conf

    if ! grep -Fqx 'LoadModule php_module modules/libphp.so' /etc/httpd/conf/httpd.conf; then
        echo 'LoadModule php_module modules/libphp.so' | sudo tee -a /etc/httpd/conf/httpd.conf >/dev/null
    fi

    if ! grep -Fqx 'Include conf/extra/php_module.conf' /etc/httpd/conf/httpd.conf; then
        echo 'Include conf/extra/php_module.conf' | sudo tee -a /etc/httpd/conf/httpd.conf >/dev/null
    fi

    if ! grep -q 'FilesMatch "\\.php\\$"' /etc/httpd/conf/httpd.conf; then
        sudo tee -a /etc/httpd/conf/httpd.conf >/dev/null <<'EOF'

<IfModule php_module>
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>
    <FilesMatch \.phps$>
        SetHandler application/x-httpd-php-source
    </FilesMatch>
</IfModule>
EOF
    fi
}

configure_php() {
    log_subsection "Enabling PHP modules"

    uncomment_ini_extension 'mysqli' "$PHP_INI"
    uncomment_ini_extension 'pdo_mysql' "$PHP_INI"
    uncomment_ini_extension 'iconv' "$PHP_INI"
}

configure_phpmyadmin() {
    log_subsection "Configuring phpMyAdmin"

    sudo tee "$PHPMYADMIN_CONF" >/dev/null <<'EOF'
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
EOF

    append_if_missing 'Include conf/extra/phpmyadmin.conf' "$HTTPD_CONF"
}

configure_wordpress_alias() {
    log_subsection "Configuring WordPress alias"

    sudo tee "$WORDPRESS_CONF" >/dev/null <<'EOF'
Alias /wordpress "/usr/share/webapps/wordpress"
<Directory "/usr/share/webapps/wordpress">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
EOF

    append_if_missing 'Include conf/extra/httpd-wordpress.conf' "$HTTPD_CONF"
}

create_test_pages() {
    log_subsection "Creating test pages"

    sudo mkdir -p "$DOCROOT"

    if [[ ! -f "${DOCROOT}/index.php" ]]; then
        echo "<?php phpinfo(); ?>" | sudo tee "${DOCROOT}/index.php" >/dev/null
    fi
}

initialize_mariadb_if_needed() {
    log_subsection "Initializing MariaDB"

    if [[ ! -d /var/lib/mysql/mysql ]]; then
        sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
        log_success "MariaDB data directory initialized"
    else
        log_warn "MariaDB data directory already exists - skipping initialization"
    fi
}

validate_apache_config() {
    log_subsection "Validating Apache configuration"

    sudo httpd -t
}

main() {
    log_section "Installing LAMP stack"

    ############################################################################################################
    # Stop services first to avoid partial reload issues during package/config changes
    ############################################################################################################

    disable_service httpd || true
    disable_service mariadb || true

    ############################################################################################################
    # Install packages
    ############################################################################################################

    install_packages apache php php-apache mariadb phpmyadmin wordpress

    ############################################################################################################
    # Configure services and software
    ############################################################################################################

    initialize_mariadb_if_needed
    configure_apache_for_php
    configure_php
    configure_phpmyadmin
    configure_wordpress_alias
    create_test_pages
    validate_apache_config

    ############################################################################################################
    # Enable and start services
    ############################################################################################################

    enable_now_service mariadb
    enable_now_service httpd

    sudo systemctl restart mariadb
    sudo systemctl restart httpd

    echo
    log_warn "Run the MariaDB secure setup now:"
    echo "sudo mariadb-secure-installation"
    echo

    log_success "LAMP stack installed"
    echo
    echo "Test URLs:"
    echo "  http://localhost/"
    echo "  http://localhost/phpmyadmin"
    echo "  http://localhost/wordpress"
}

main "$@"