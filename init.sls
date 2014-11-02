# Install mysql, a mysql client, and run a brief attempt at tuning based on
# available system memory.

mysql-software:
  pkg.installed:
    - pkgs:
      - python-mysqldb
      - mysql-server

/etc/mysql/my.cnf:
  file.managed:
    - name: /etc/mysql/my.cnf
    - template: jinja
    - source: salt://mysql/files/mysql.cnf
    - user: root
    - group: root
    - mode: 644

mysql-server:
  service:
    - running
    - name: mysql
    - watch:
      - file: /etc/mysql/my.cnf

# When installing mysql by itself, no root password is set
# Generate a random root password and save in /root/.my.cnf
{% if 1 == salt['cmd.retcode']('test -f /root/.my.cnf') %}
{% set pw = salt['cmd.run']('openssl rand -base64 32').split()[0] %}

root_db_user:
  mysql_user.present:
    - name: root
    - password: {{ pw }}
    - host: localhost
    - requires:
      - service: mysql-server

/root/.my.cnf:
  file.managed:
    - source: salt://mysql/files/root.cnf
    - template: jinja
    - mode: 700
    - defaults:
        user: root
        password: {{ pw }}
    - requires:
      - mysql_user: root_db_user

{% endif %}
