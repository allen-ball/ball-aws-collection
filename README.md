# Ball AWS Collection

[![Version](https://img.shields.io/badge/version-3.1.3-blue.svg)](galaxy.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A collection of miscellaneous [Ansible](https://www.ansible.com/) roles for [AWS](https://aws.amazon.com/).

## Overview

**Collection Details:**
- **Namespace**: `ball`
- **Name**: `aws`
- **Version**: 3.1.3
- **License**: MIT
- **Repository**: https://github.com/allen-ball/ball-aws-collection.git
- **Author**: Allen D. Ball <ball@hcf.dev>
- **Description**: A collection of miscellaneous Ansible roles for AWS

## Installation

Add to your `requirements.yml`:

```yaml
collections:
  - name: https://github.com/allen-ball/ball-aws-collection.git
    type: git
    version: trunk
```

Install the collection:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Prerequisites

- Ansible 2.9+
- Python 3.8+
- AWS CLI configured with appropriate credentials

## Available Roles

| Role | Description | Documentation |
|:-----|:------------|:--------------|
| [aws-user-data] | Generate AWS EC2 User Data Shell Scripts for instance initialization | [README](roles/aws-user-data/README.md) |
| [aws-rc] | Install common `/etc/aws.rc` script for AWS environment configuration | [README](roles/aws-rc/README.md) |
| [auto-ebs] | Configure automount/autofs Executable Map for automatic Amazon EBS Volume mounting | [README](roles/auto-ebs/README.md) |
| [EC2AWSRCPolicy] | IAM policy definition for EC2 instances using aws-rc and auto-ebs roles | [README](roles/EC2AWSRCPolicy/README.md) |

[aws-user-data]: roles/aws-user-data
[aws-rc]: roles/aws-rc
[auto-ebs]: roles/auto-ebs
[EC2AWSRCPolicy]: roles/EC2AWSRCPolicy

## Quick Start

```yaml
# playbook-aws.yml
---
- hosts: localhost
  connection: local
  gather_facts: no
  collections:
    - ball.aws
  roles:
    - role: aws-rc
    - role: auto-ebs
```

## Required IAM Policy

These roles require the EC2 instance role to include the [EC2AWSRCPolicy](roles/EC2AWSRCPolicy):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DescribeInstances",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
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
                "ec2:DeleteTags",
                "ec2:CreateVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ]
        }
    ]
}
```

## Key Features

- **EC2 User Data**: Automated instance initialization scripts
- **AWS Environment Configuration**: Standard `/etc/aws.rc` for environment variables
- **Automatic EBS Mounting**: autofs integration for seamless EBS volume access
- **IAM Policy Templates**: Pre-defined policies for secure operation

## Additional Resources

- [AWS EC2 User Data Shell Script Blog Post](https://blog.hcf.dev/article/2018-08-22-aws-user-data-script)
- [automount/autofs Executable Map for Amazon EBS Volumes Blog Post](https://blog.hcf.dev/article/2018-08-20-auto-ebs-map)

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/allen-ball/ball-aws-collection/issues)
- Contact: ball@hcf.dev

## License

This collection is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

---

**Copyright © 2019-2025 Allen D. Ball. All rights reserved.**
