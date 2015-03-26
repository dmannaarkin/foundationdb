#
# Cookbook Name:: foundationdb
# Recipe:: client
#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# All rights reserved - Do Not Redistribute
#
Chef::Log.info 'Installing FoundationDB client'
if node['foundationdb']['clients_url']
  clients_file = node['foundationdb']['clients_url'].split("/").last
  clients_temp_file = "/tmp/#{clients_file}"

  remote_file clients_temp_file do
    source node['foundationdb']['clients_url']
    mode 00755
  end
else
  clients_file = "foundationdb-clients_#{node['foundationdb']['version']}-1_amd64.deb"
  clients_temp_file = "/tmp/#{clients_file}"

  cookbook_file clients_file do
    path clients_temp_file
    mode 00755
    action :create
  end
end

dpkg_package 'foundationdb-clients' do
  source clients_temp_file
  action [:install]
end

directory '/etc/foundationdb' do
  mode 00777
  action :create
end

# Delete temp files
file clients_temp_file do
  action :delete
end
