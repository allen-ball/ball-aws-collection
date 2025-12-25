# GitHub Copilot Instructions for Ball AWS Collection

## Project Overview

This is an Ansible collection repository containing miscellaneous AWS automation roles focused on EC2 instance configuration and EBS volume management.

- **Collection Namespace**: `ball.aws`
- **Version**: 3.1.2
- **Primary Language**: YAML (Ansible playbooks and roles), Shell scripts
- **Purpose**: AWS EC2 instance automation, EBS volume mounting, and environment configuration
- **License**: MIT

## Repository Structure

```
ball-aws-collection/
├── galaxy.yml              # Ansible Galaxy collection metadata
├── roles/                  # All Ansible roles
│   ├── aws-user-data/     # EC2 User Data script generation
│   ├── aws-rc/            # /etc/aws.rc environment configuration
│   ├── auto-ebs/          # autofs executable map for EBS volumes
│   └── EC2AWSRCPolicy/    # Required IAM policy definition
└── .github/               # GitHub-specific files
```

## Technology Stack

- **Ansible**: 2.9+
- **Python**: 3.8+
- **Shell**: Bash (for generated scripts)
- **AWS Services**: EC2, EBS, IAM
- **System Tools**: autofs/automount

## Key Concepts

### Role Descriptions

1. **aws-user-data** - Generates EC2 User Data shell scripts for instance initialization
2. **aws-rc** - Installs `/etc/aws.rc` script providing AWS environment configuration
3. **auto-ebs** - Configures autofs executable map for automatic EBS volume mounting
4. **EC2AWSRCPolicy** - IAM policy template granting required EC2 permissions

### Required IAM Permissions

All roles require EC2 instances to have an IAM role with the EC2AWSRCPolicy:
- `ec2:DescribeImages` - Retrieve AMI information
- `ec2:DescribeInstances` - Query instance metadata
- `ec2:AttachVolume` - Attach EBS volumes
- `ec2:CreateVolume` - Create new EBS volumes
- `ec2:CreateTags` - Tag EBS volumes
- `ec2:DeleteTags` - Remove tags from EBS volumes

### Ansible Best Practices for This Project

- **Idempotency**: All roles should be idempotent (safe to run multiple times)
- **Variables**: Use role defaults in `defaults/main.yml`, define required vars in README
- **Documentation**: Each role should have a comprehensive README.md
- **Simplicity**: Keep roles focused on specific tasks

## Coding Guidelines

### YAML Style

```yaml
# Use 2-space indentation
- name: Descriptive task name
  module_name:
    parameter: value
    another_parameter: "{{ variable }}"
  tags:
    - configuration
    - aws
```

### Variable Naming

- Use descriptive names: `aws_ebs_volume_id` not `vol_id`
- Prefix role-specific vars: `aws_rc_config_path`
- Use snake_case for all variables

### Task Structure

- Always include `name:` for clarity
- Use appropriate modules (prefer AWS collection modules over shell)
- Add `tags:` for flexibility
- Include `when:` conditions for conditional execution

### File Organization

```
role_name/
├── README.md              # Role documentation
├── defaults/
│   └── main.yml          # Default variables
├── tasks/
│   └── main.yml          # Main task file
├── files/                # Static files (scripts, configs)
└── templates/            # Jinja2 templates
```

## Common Patterns

### AWS Credential Handling

Roles expect AWS credentials via:
- IAM instance profiles (preferred for EC2 instances)
- Environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- AWS CLI profiles

### Script Generation

When generating shell scripts:

```yaml
- name: Generate script from template
  template:
    src: script.sh.j2
    dest: /usr/local/bin/script.sh
    mode: '0755'
    owner: root
    group: root
```

### autofs Configuration

The auto-ebs role creates executable maps:

```bash
#!/bin/bash
# autofs executable map that mounts EBS volumes on-demand
```

## Testing Recommendations

### For Roles:
1. **Syntax Check**: `ansible-playbook --syntax-check playbook.yml`
2. **Linting**: Use `ansible-lint` for best practices
3. **Dry Run**: Use `--check` mode when possible
4. **EC2 Testing**: Test on actual EC2 instances with appropriate IAM roles

### For Generated Scripts:
1. **ShellCheck**: Validate shell scripts with `shellcheck`
2. **Manual Testing**: Test scripts on target EC2 instances
3. **Permission Verification**: Ensure IAM policies allow required actions

## AWS Services Covered

- **Compute**: EC2 (User Data, instance metadata)
- **Storage**: EBS (volume attachment, mounting)
- **Identity**: IAM (policies, instance profiles)

## Related Resources

- [AWS EC2 User Data Shell Script Blog Post](https://blog.hcf.dev/article/2018-08-22-aws-user-data-script)
- [automount/autofs Executable Map for Amazon EBS Volumes Blog Post](https://blog.hcf.dev/article/2018-08-20-auto-ebs-map)

## When Writing New Roles

1. Follow existing role structure patterns
2. Document all variables in README.md
3. Include examples in the README
4. Keep roles focused (single responsibility)
5. Consider IAM permission requirements
6. Test on actual EC2 instances

## When Modifying Existing Roles

1. Maintain backward compatibility when possible
2. Update role version in galaxy.yml
3. Test against existing playbooks
4. Update documentation if behavior changes
5. Preserve existing variable names and structure

## Security Considerations

- Never commit AWS credentials or secrets
- Document required IAM permissions per role
- Validate user inputs in tasks
- Use least privilege principle for IAM policies
- Test scripts for security vulnerabilities

## Documentation Standards

### Role README.md Structure

Each role MUST have a comprehensive README.md following this structure:

1. **Title**: `# ball.aws.role-name Role`
2. **Brief Description**: One-line summary
3. **Description**: Detailed explanation of purpose and functionality
4. **Requirements**: Ansible version, AWS services, IAM permissions
5. **Role Variables**: Tables for required and optional variables
6. **Example Playbook**: Complete working example
7. **IAM Permissions**: Required AWS permissions
8. **Notes**: Important operational notes
9. **Author**: Allen D. Ball <ball@hcf.dev>
10. **License**: MIT

### Variable Documentation Format

```markdown
### Required Variables

| Variable | Type | Description | Default |
|:---------|:-----|:------------|:--------|
| `var_name` | string | What it does | N/A |

### Optional Variables

| Variable | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `var_name` | string | `value` | What it does |
```

## License and Copyright

### Collection License

This collection is **open source software** licensed under the MIT License.

- **License File**: MIT License at repository root: `LICENSE`
- **Copyright**: © 2019-2025 Allen D. Ball
- **Contact**: Allen D. Ball <ball@hcf.dev>

### License Headers

Shell scripts should include MIT license headers or references.

## Version Management

- **Semantic Versioning**: MAJOR.MINOR.PATCH (e.g., 3.1.2)
- **galaxy.yml**: Single source of truth for version number
- **Badges**: Update version badge in README.md when bumping version

## Code Review Checklist

Before committing changes:

- [ ] README.md updated if behavior changed
- [ ] All variables documented
- [ ] Example playbook tested and working
- [ ] IAM permissions documented
- [ ] No credentials or secrets in code
- [ ] Idempotency verified
- [ ] Version bumped in galaxy.yml if needed
- [ ] Shell scripts pass shellcheck
- [ ] License headers present where appropriate

## Collection Metadata

**Namespace**: ball  
**Name**: aws  
**Version**: 3.1.2  
**Author**: Allen D. Ball <ball@hcf.dev>  
**License**: MIT  
**Repository**: https://github.com/allen-ball/ball-aws-collection.git
