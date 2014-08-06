# Debian currently uses the lucid package for Ubuntu
{% if grains['os'] == "Debian" %}
{% set repo = "lucid" %}
{% elif grains['os'] == "Ubuntu" %}
{% set repo = grains['oscodename'] %}
{% endif %}

rethinkdb-pkgrepo:
  pkgrepo.managed:
    - humanname: RethinkDB PPA
    - name: deb http://download.rethinkdb.com/apt {{ repo }} main
    - file: /etc/apt/sources.list.d/rethinkdb.list
    - key_url: http://download.rethinkdb.com/apt/pubkey.gpg
    - require_in:
      - pkg: rethinkdb

rethinkdb:
  user.present:
    - createhome: false
    - gid_from_name: true
  pkg.installed:
    - version: 1.13.3-0ubuntu1~{{ repo }}


python-pip-rethinkdb:
  pkg.installed:
    - name: python-pip

rethinkdb-python-driver:
  pip.installed:
    - name: rethinkdb
    - require:
      - pkg: python-pip-rethinkdb


rethinkdb-chown-lib:
  file.directory:
    - name: /var/lib/rethinkdb
    - user: rethinkdb
    - group: rethinkdb
    - require:
      - pkg: rethinkdb

rethinkdb-config:
  file.managed:
    - name: /etc/rethinkdb/instances.d/{{ pillar['app_name'] }}.conf
    - source: salt://rethinkdb/rethinkdb.instance.conf
    - template: jinja
    - user: rethinkdb
    - group: rethinkdb
    - defaults:
        app_name: {{ pillar['app_name'] }}
        data_directory: null
        production: true
        host: null
        canonical_address: null
        join: []
    - require:
      - pkg: rethinkdb
      - user: rethinkdb
  cmd.wait:
    - name: /etc/init.d/rethinkdb restart
    - require:
      - file: rethinkdb-chown-lib
    - watch:
      - file: rethinkdb-config