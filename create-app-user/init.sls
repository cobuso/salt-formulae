include:
  - github

{% set app_user = pillar.get('app_user', pillar.get('login_user', 'root')) %}

create-app-user:
  group.present:
    - name: {{ app_user }}
  user.present:
    - name: {{ app_user }}
    - home: /home/{{ app_user }}
    - shell: /bin/bash
    - gid_from_name: true
    - remove_groups: false
    - require:
      - group: {{ app_user }}
    - order: first
    - require_in:
      - file: ssh-home-dir
