#!/bin/bash
# ----------------------------------------------------------------------------
# user-data.bash
# ----------------------------------------------------------------------------
export LANG=en_US.UTF-8
export LC_ALL=${LANG}

if [ -e /usr/bin/apt ]; then
    apt -y update
    apt -y install awscli
else
    yum -y update

    if [ ! -e /usr/libexec/platform-python ]; then
        yum -y install python
    fi

    if [ ! -e /usr/bin/pip -a -x /usr/bin/easy_install ]; then
        /usr/bin/easy_install --prefix /usr pip
    fi

    /usr/bin/pip install --prefix /usr --upgrade pip
    /usr/bin/pip install --prefix /usr --upgrade awscli
fi
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
{{ lookup('ansible.builtin.template', '../../aws-rc/templates/etc/aws.rc') }}
# ----------------------------------------------------------------------------
# Create users and install respective .ssh/authorized_keys for public-keys'
# metadata
# ----------------------------------------------------------------------------
getent group sudo >> /dev/null 2>&1

if [ $? -eq 0 ]; then
    wheel=sudo
else
    wheel=wheel
fi

for key in $(metadata public-keys/); do
    username=${key#*=}

    useradd -G ${wheel} -m -s /bin/bash -U ${username}
    userhome=$(eval echo ~${username})

    mkdir -p ${userhome}/.ssh
    echo "$(metadata public-keys/${key%%=*}/openssh-key)" >> ${userhome}/.ssh/authorized_keys
    chown -R ${username}:${username} ${userhome}/.ssh
    chmod -R go-rwx ${userhome}/.ssh

    file=/etc/sudoers.d/user-data-${username}
    echo "${username} ALL=(ALL) NOPASSWD:ALL" > ${file}
    chmod a-wx,o-r ${file}
done
# ----------------------------------------------------------------------------
# Attach local volumes and manage file systems
#
# File system volumes must define the following tags:
#         host
#         fstype
#         mntpt
#
# This script will update the volume's "uuid" tag.
# ----------------------------------------------------------------------------
export HOST=$(metadata local-ipv4)
export VOLUMES=$(ec2 describe-volumes \
                       --filters Name=tag:host,Values=${HOST} \
                       --output text --query 'Volumes[*].VolumeId')

if [ -n "${VOLUMES}" ]; then
    for volume in ${VOLUMES}; do
        fstype=$(ec2-get-tag-value ${volume} fstype)

        if [ "${fstype}" != "" ]; then
            device=$(next-unattached-block-device)

            ec2-attach-volume ${volume} ${device}

            if [ "$(file -b -s ${device})" == "data" ]; then
                volume-mkfs ${volume} ${device} ${fstype}
            fi

            uuid=$(ec2-get-tag-value ${volume} uuid)
            mntpt=$(ec2-get-tag-value ${volume} mntpt)

            if [ "${uuid}" != "" -a "${mntpt}" != "" ]; then
                mkdir -p ${mntpt}
                echo "# ${volume} ${device}" >> /etc/fstab
                echo "UUID=${uuid} ${mntpt} ${fstype} defaults 0 2" >> /etc/fstab
            fi
        fi
    done
fi

if [ -f /var/run/reboot-required ]; then
    shutdown -r +1
else
    mount -a
fi

exit 0
