aws-user-data Role
==================

This role provides an [AWS] EC2 launch script that provides two services:

1. Adds any specified users and includes them in the sudo/wheel group
2. Attaches any EBS volumes tagged with this instance's IP address, creates a
   file system (if necessary), and updates the `/etc/fstab` file.

Please see the [blog post][AWS EC2 User Data Shell Script] for more
information.

Consider the following [Ansible] example to launch a MongoDB servers with an
EBS volume that will survive the EC2 instance termination:

```yml
...
    mongodb_servers: [ 10.5.128.5 ]
...
- name: /var/lib/mongodb EBS filesystems
  vars:
    fstype: xfs
    mntpt: /var/lib/mongodb
  amazon.aws.ec2_vol:
    name: "{{ item }}:{{ mntpt }}"
    instance: None
    volume_size: 1024
    volume_type: st1
    tags:
      Name: "{{ item }}:{{ mntpt }}"
      host: "{{ item }}"
      fstype: "{{ fstype }}"
      mntpt: "{{ mntpt }}"
  loop: "{{ mongodb_servers }}"

- name: Mongo Servers
  community.aws.ec2_instance:
    name: "{{ item }}"
    ...
    user_data: "{{ user_data | default(omit) }}"
    ...
    wait: yes
  loop: "{{ mongodb_servers }}"
```


[Ansible]: https://www.ansible.com/
[AWS]: https://aws.amazon.com/

[AWS EC2 User Data Shell Script]: https://blog.hcf.dev/article/2018-08-22-aws-user-data-script
