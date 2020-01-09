# --------------------------------------------
# Description: 
#
# Customer: AIV
#
# Reviewer: fernando.alvareznoya@bryxx.eu
#
# Date: 12/2019
# 
# Devops <Devops@bryxx.eu>
# Copyright 2019 Bryxx nv
# --------------------------------------------

class general::system {

  $ntp_server_1 = lookup('ntp_server_1')
  $ntp_server_2 = lookup('ntp_server_2')

# SELinux Settings
# --------------------------------------------
  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }

# Disable the firewalld
# --------------------------------------------
  service { 'firewalld':
      ensure => 'stopped',
      enable => false,
    }

# Update and restart the ntp service (Europe/Brussels)
# --------------------------------------------
  class { 'timezone':
    timezone => 'Europe/Brussels',
  }
  class { 'ntp':
    servers => [ $ntp_server_1, $ntp_server_2 ],
  }
  service { 'chronyd':
    ensure => 'stopped',
    enable => false,
  }

# Setup SSHD
# --------------------------------------------
  service { 'sshd':
    ensure => 'running',
    enable => true,
  }

  sshd_config { 'PermitRootLogin':
    ensure => present,
    value  => 'yes',
    notify => Service[sshd],
  }

  sshd_config { 'AddressFamily':
    ensure => present,
    value  => 'inet',
    notify => Service[sshd],
  }

# Settings sudo
# --------------------------------------------
  sudo::user_specification { 'power_users':
    user_list => ['%bryxxadmin, %moninadmin'],
    runas     => 'root',
    cmnd      => [ '/usr/su root', '/bin/su - root'],
    passwd    => false,
  }

  sudo::user_specification { 'oracle':
    user_list => ['oracle'],
    runas     => 'root',
    cmnd      => [ '/u01/app/oracle/oraInventory/orainstRoot.sh',
                    '/u01/app/oracle/product/12.1.0/root.sh'],
    passwd    => false,
  }

  sudo::alias::cmnd { 'STORAGE':
    content => ['/sbin/fdisk', '/sbin/sfdisk', '/sbin/parted', '/sbin/partprobe', '/bin/mount',
                '/bin/umount'],
  }

  sudo::alias::cmnd { 'SU':
    content => ['/sbin/visudo', '/bin/su - root', '/bin/su -', '/bin/su -iu root',
                '/bin/vi /etc/sudoers', '/bin/vim /etc/sudoers', '/bin/su',
                '/bin/su - mspadmin', '/bin/su -iu mspadmin'],
  }

  sudo::alias::cmnd { 'DRIVERS':
    content => ['/sbin/modprobe'],
    }

  sudo::alias::cmnd { 'BOOT':
    content => ['/sbin/shutdown', '/sbin/halt']
  }
}
