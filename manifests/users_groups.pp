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

class general::users_groups {

#Definitions for users, groups, ssh-keys, ntp
# --------------------------------------------

  $oracle_user = lookup('oracle_user')
  $oracle_pass = lookup('oracle_pass')
  $oracle_group = lookup('oracle_group')
  $oracle_ssh_type = lookup('oracle_ssh_type')
  $oracle_ssh_key = lookup('oracle_ssh_key')
  $bryxx_user = lookup('bryxx_user')
  $bryxx_uid = lookup('bryxx_uid')
  $bryxx_pass = lookup('bryxx_pass')
  $bryxx_group = lookup('bryxx_group')
  $bryxx_gid = lookup('bryxx_gid')
  $bryxx_ssh_type = lookup('bryxx_ssh_type')
  $bryxx_ssh_key = lookup('bryxx_ssh_key')
  $monin_user = lookup('monin_user')
  $monin_uid = lookup('monin_uid')
  $monin_pass = lookup('monin_pass')
  $monin_group = lookup('monin_group')
  $monin_gid = lookup('monin_gid')
  $monin_ssh_type = lookup('monin_ssh_type')
  $monin_ssh_key = lookup('monin_ssh_key')
  $oracc_user = lookup('oracc_user')
  $oracc_pass = lookup('oracc_pass')
  $oracc_ssh_type = lookup('oracc_ssh_type')
  $oracc_ssh_key = lookup('oracc_ssh_key')


# Creation of special users and groups
# --------------------------------------------
  group { $oracle_group:
    ensure => present,
  }

  group { $bryxx_group:
    ensure => present,
    gid    => $bryxx_gid,
  }

  group { $monin_group:
    ensure => present,
    gid    => $monin_gid,
  }

  user { $oracle_user:
    ensure   => present,
    shell    => '/bin/bash',
    home     => "/home/${$oracle_user}",
    groups   => $oracle_group,
    password => $oracle_pass,
    require  => Group[$oracle_group],
  }

  user { $bryxx_user:
    ensure   => present,
    uid      => $bryxx_uid,
    shell    => '/bin/bash',
    home     => "/home/${$bryxx_user}",
    groups   => [$oracle_group, $bryxx_group],
    password => $bryxx_pass,
    require  => [ Group[$bryxx_group], Group[$oracle_group] ],
  }

  user { $monin_user:
    ensure   => present,
    uid      => $monin_uid,
    shell    => '/bin/bash',
    home     => "/home/${$monin_user}",
    groups   => [$oracle_group, $monin_group],
    password => $monin_pass,
    require  => [ Group[$bryxx_group], Group[$oracle_group] ],
  }

  user { $oracc_user:
    ensure   => present,
    shell    => '/bin/bash',
    home     => "/home/${$oracc_user}",
    groups   => $oracle_group,
    password => $oracc_pass,
  }

# Configure the SSH Keys for the users
# --------------------------------------------

  ssh_authorized_key { $oracle_user:
    ensure  => present,
    user    => $oracle_user,
    type    => $oracle_ssh_type,
    key     => $oracle_ssh_key,
    require => User[$oracle_user],
  }

  ssh_authorized_key { $bryxx_user:
    ensure  => present,
    user    => $bryxx_user,
    type    => $bryxx_ssh_type,
    key     => $bryxx_ssh_key,
    require => User[$bryxx_user],
  }

  ssh_authorized_key { $monin_user:
    ensure  => present,
    user    => $monin_user,
    type    => $monin_ssh_type,
    key     => $monin_ssh_key,
    require => User[$monin_user],
  }

  ssh_authorized_key { $oracc_user:
    ensure  => present,
    user    => $oracc_user,
    type    => $oracc_ssh_type,
    key     => $oracc_ssh_key,
    require => User[$oracc_user],
  }
}
