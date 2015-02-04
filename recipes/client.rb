#
# Cookbook Name:: foundationdb
# Recipe:: client
#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# All rights reserved - Do Not Redistribute
#
node.default['foundationdb']['base_url'] = "https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/#{node['foundationdb']['version']}"

# Debian/Ubuntu/Linux Mint
node.default['foundationdb']['clients_file']['debian'] = "foundationdb-clients_#{node['foundationdb']['version']}#{node['foundationdb']['dash_string']}_amd64.deb"
node.default['foundationdb']['server_file']['debian'] = "foundationdb-server_#{node['foundationdb']['version']}#{node['foundationdb']['dash_string']}_amd64.deb"
node.default['foundationdb']['clients_source_url']['debian'] = "#{node['foundationdb']['base_url']}/#{node['foundationdb']['clients_file']['debian']}"
node.default['foundationdb']['server_source_url']['debian'] = "#{node['foundationdb']['base_url']}/#{node['foundationdb']['server_file']['debian']}"

# RHEL/CentOS/Amazon Linux/Oracle Linux/Scientific Linux
node.default['foundationdb']['clients_file']['rhel'] = "foundationdb-clients-#{node['foundationdb']['version']}#{node['foundationdb']['dash_string']}.x86_64.rpm"
node.default['foundationdb']['server_file']['rhel'] = "foundationdb-server-#{node['foundationdb']['version']}#{node['foundationdb']['dash_string']}.x86_64.rpm"
node.default['foundationdb']['clients_source_url']['rhel'] = "#{node['foundationdb']['base_url']}/#{node['foundationdb']['clients_file']['rhel']}"
node.default['foundationdb']['server_source_url']['rhel'] = "#{node['foundationdb']['base_url']}/#{node['foundationdb']['server_file']['rhel']}"

clients_temp_file = "#{node['foundationdb']['temp_dir']}/#{node['foundationdb']['clients_file'][node['platform_family']]}"

Chef::Log.info 'Installing FoundationDB client'
remote_file clients_temp_file do
  source node['foundationdb']['clients_source_url'][node['platform_family']]
  owner 'root'
  group 'root'
  mode 00755
end

case node['platform_family']
when 'debian'
  dpkg_package 'foundationdb-clients' do
    source clients_temp_file
    action [:install]
  end
when 'rhel'
  rpm_package 'foundationdb-clients' do
    source clients_temp_file
    action [:install]
  end
end

directory '/etc/foundationdb' do
  owner 'root'
  group 'root'
  mode 00777
  recursive true
  action :create
end

# Delete temp files
if node['foundationdb']['cleanup']
  file clients_temp_file do
    action :delete
  end
end
