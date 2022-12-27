ball-aws-collection
===================

A collection of miscellaneous [Ansible] roles for [AWS].

| Role                                       | Description                                              |
|--------------------------------------------|----------------------------------------------------------|
| [roles/aws-user-data](roles/aws-user-data) | [AWS EC2 User Data Shell Script]                         |
| [roles/auto.ebs](roles/auto.ebs)           | [automount/autofs Executable Map for Amazon EBS Volumes] |

Add to `requirements.yml`:

```yml
collections:
  - name: https://github.com/allen-ball/ball-aws-collection.git
    type: git
    version: trunk
```


[Ansible]: https://www.ansible.com/
[AWS]: https://aws.amazon.com/

[AWS EC2 User Data Shell Script]: https://blog.hcf.dev/article/2018-08-22-aws-user-data-script
[automount/autofs Executable Map for Amazon EBS Volumes]: https://blog.hcf.dev/article/2018-08-20-auto-ebs-map
