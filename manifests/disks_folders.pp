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

class general::disks_folders {

  $oracle_user = lookup('oracle_user')
  $oracle_group = lookup('oracle_group')

# Preparing main folders
# --------------------------------------------
  $main_folders = [ '/u01',
                    '/u02/oracle/data',
                    '/u02/oracle/data/installer',
                    '/u02/oracle/redo',
                    '/u02/oracle/archive' ]

  file { $main_folders:
    ensure => 'directory',
    owner  => $oracle_user,
    group  => $oracle_group,
  }


# Setting LVM (assume exist the partitions)
# --------------------------------------------
# Create physical volume's
  $the_physical_volumes = [ '/dev/xvdc1',
                            '/dev/xvdd1',
                            '/dev/xvde1',
                            '/dev/xvdf1',
                            '/dev/xvdg1',
                            '/dev/xvdh1',
                            '/dev/xvdi1',
                            '/dev/xvdj1' ]

  physical_volume { $the_physical_volumes:
    ensure => present,
  }

# Create volume group's
  volume_group { 'vg_bin':
    ensure           => present,
    physical_volumes => '/dev/xvdc1',
    require          => Physical_volume['/dev/xvdc1'],
  }

  volume_group { 'vg_data':
    ensure           => present,
    physical_volumes => ['/dev/xvdd1', '/dev/xvde1', '/dev/xvdf1', '/dev/xvdg1'],
    require          => [ Physical_volume['/dev/xvdd1'], Physical_volume['/dev/xvde1'],
                          Physical_volume['/dev/xvdf1'], Physical_volume['/dev/xvdg1'] ],
  }

  volume_group { 'vg_redo':
    ensure           => present,
    physical_volumes => '/dev/xvdh1',
    require          => Physical_volume['/dev/xvdh1'],
  }

  volume_group { 'vg_archive':
    ensure           => present,
    physical_volumes => ['/dev/xvdi1', '/dev/xvdj1'],
    require          => [ Physical_volume['/dev/xvdi1'], Physical_volume['/dev/xvdj1'] ]
  }

# Create logical volume's
  logical_volume { 'lv_u01':
    ensure       => present,
    volume_group => 'vg_bin',
    require      => Volume_group['vg_bin'],
  }

  logical_volume { 'lv_u02_data':
    ensure       => present,
    volume_group => 'vg_data',
    require      => Volume_group['vg_data'],
  }

  logical_volume { 'lv_u02_redo':
    ensure       => present,
    volume_group => 'vg_redo',
    require      => Volume_group['vg_redo'],
  }

  logical_volume { 'lv_u02_archive':
    ensure       => present,
    volume_group => 'vg_archive',
    require      => Volume_group['vg_archive'],
  }

# Format the partition's
  filesystem { '/dev/vg_bin/lv_u01':
    ensure  => present,
    fs_type => 'ext4',
    require => Logical_volume['lv_u01'],
  }

  filesystem { '/dev/vg_data/lv_u02_data':
    ensure  => present,
    fs_type => 'ext4',
    require => Logical_volume['lv_u02_data'],
  }

  filesystem { '/dev/vg_redo/lv_u02_redo':
    ensure  => present,
    fs_type => 'ext4',
    require => Logical_volume['lv_u02_redo'],
  }

  filesystem { '/dev/vg_archive/lv_u02_archive':
    ensure  => present,
    fs_type => 'ext4',
    require => Logical_volume['lv_u02_archive'],
  }

# Setting Fstab
# --------------------------------------------
  mounttab { '/u01':
    ensure   => present,
    device   => '/dev/vg_bin/lv_u01',
    fstype   => 'ext4',
    options  => 'defaults',
    dump     => '0',
    pass     => '2',
    provider => augeas,
    require  => [ Filesystem['/dev/vg_bin/lv_u01'], File[$main_folders] ],
  }

  mounttab { '/u02/oracle/data':
    ensure   => present,
    device   => '/dev/vg_data/lv_u02_data',
    fstype   => 'ext4',
    options  => 'defaults',
    dump     => '0',
    pass     => '2',
    provider => augeas,
    require  => [ Filesystem['/dev/vg_data/lv_u02_data'], File[$main_folders] ],
  }

  mounttab { '/u02/oracle/redo':
    ensure   => present,
    device   => '/dev/vg_redo/lv_u02_redo',
    fstype   => 'ext4',
    options  => 'defaults',
    dump     => '0',
    pass     => '2',
    provider => augeas,
    require  => [ Filesystem['/dev/vg_redo/lv_u02_redo'], File[$main_folders] ],
  }

  mounttab { '/u02/oracle/archive':
    ensure   => present,
    device   => '/dev/vg_archive/lv_u02_archive',
    fstype   => 'ext4',
    options  => 'defaults',
    dump     => '0',
    pass     => '2',
    provider => augeas,
    require  => [ Filesystem['/dev/vg_archive/lv_u02_archive'], File[$main_folders] ],
  }
}
