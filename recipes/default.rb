#
# Cookbook Name:: wpapp
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

apache_site "default" do
  enable false
end

mysql_database node['wpapp']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
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

wp_secrets = Chef::Config[:file_cache_path] + '/wp-secrets.php'

if File.exist?(wp_secrets)
  salt_data = File.read(wp_secrets)
else
  require 'open-uri'
  salt_data = open('https://api.wordpress.org/secret-key/1.1/salt/').read
  open(wp_secrets, 'wb') do |file|
    file << salt_data
  end
end

template node['wpapp']['path'] + '/wp-config.php' do
  source 'wp-config.php.erb'
  mode 0755
  owner 'root'
  group 'root' 
  variables(
    :database        => node['wpapp']['database'],
    :user            => node['wpapp']['db_username'],
    :password        => node['wpapp']['db_password'],
    :wp_secrets      => salt_data)
end

web_app 'wpapp' do
  template 'site.conf.erb'
  docroot node['wpapp']['path']
  server_name node['wpapp']['server_name']
end

