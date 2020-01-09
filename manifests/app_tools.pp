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

class general::app_tools {
# For install this components:

  $packages_to_install = [ 'screen', 'htop', 'iotop', 'systat',
                          'vim', 'net-tools', 'wget', 'nmon', 'ftp' ]

  package { $packages_to_install:
    ensure => present,
  }
}
