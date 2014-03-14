#
# Cookbook Name:: wpapp
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

apache_site "default" do
  enable true
end

mysql_database_user node['wpapp']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['wpapp']['db_password']
  database_name node['wpapp']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

