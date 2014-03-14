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

wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"

remote_file wordpress_latest do
  source "http://wordpress.org/latest.tar.gz"
  mode "0644"
end

directory node["wpapp"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd node['wpapp']['path']
  command "tar --strip-components 1 -xzf " + wordpress_latest
  creates node['wpapp']['path'] + "/wp-settings.php"
end

