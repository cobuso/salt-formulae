include:
  - hostname

rabbitmq-python-apt:
  pkg.installed:
    - name: python-apt

rabbitmq-server:
  pkg.installed:
    - require:
      - cmd: set-hostname
  service.running:
    - enable: true
    - require:
      - pkg: rabbitmq-server

# ensure rabbitmq is running
rabbitmq-server-running:
  cmd.run:
    - name: rabbitmq-server -detached
    - onlyif: rabbitmqctl status 2>&1 | grep nodedown
    - require:
      - pkg: rabbitmq-server

# remove the rabbitmq guest account
rabbitmq-guest-remove:
  rabbitmq_user.absent:
    - require:
      - pkg: rabbitmq-server

# create rabbitmq user/vhost from pillar
{% if pillar.get('rabbitmq_user', False) %}
rabbitmq-user:
  rabbitmq_user.present:
    - name: {{ pillar['rabbitmq_user'] }}
    - password: {{ pillar['rabbitmq_pass'] }}
    - require:
      - pkg: rabbitmq-server

rabbitmq-vhost:
  rabbitmq_vhost.present:
    - name: {{ pillar['rabbitmq_vhost'] }}
    - user: {{ pillar['rabbitmq_user'] }}
    - require:
      - rabbitmq_user: rabbitmq-user
{% endif %}
