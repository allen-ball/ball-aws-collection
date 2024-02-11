ball-aws-collection
===================

A collection of miscellaneous [Ansible] roles for [AWS].

| Role                                       | Description                                              |
|--------------------------------------------|----------------------------------------------------------|
| [roles/aws-user-data](roles/aws-user-data) | [AWS EC2 User Data Shell Script]                         |
| [roles/aws-rc](roles/aws-rc)               | Common `/etc/aws.rc` script                              |
| [roles/auto.ebs](roles/auto.ebs)           | [automount/autofs Executable Map for Amazon EBS Volumes] |

Add to `requirements.yml`:

```yml
collections:
  - name: https://github.com/allen-ball/ball-aws-collection.git
    type: git
    version: trunk
```

These scripts require the EC2 role include the following
[policy](roles/EC2AWSRCPolicy):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DescribeInstances",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "AttachVolumes",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Sid": "CreateAndModifyVolumes",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:CreateVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ]
        }
    ]
}
```


[Ansible]: https://www.ansible.com/
[AWS]: https://aws.amazon.com/

[AWS EC2 User Data Shell Script]: https://blog.hcf.dev/article/2018-08-22-aws-user-data-script
[automount/autofs Executable Map for Amazon EBS Volumes]: https://blog.hcf.dev/article/2018-08-20-auto-ebs-map
