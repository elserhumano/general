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

class general {

  include general::app_tools
  include general::users_groups
  include general::system
  include general::disks_folders
}

# To Do ###################################################
/*
Is a kernel parameter, check this!
***cat "vm.swappiness = 10" >> /etc/sysctl.conf ???????
***sysctl -p ?????
*/
