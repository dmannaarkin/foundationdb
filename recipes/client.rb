#
# Cookbook Name:: foundationdb
# Recipe:: client
#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# All rights reserved - Do Not Redistribute
#
if node['foundationdb']['clients_url']
  clients_source_url = node['foundationdb']['clients_url']
else
  base_url = "#{node['foundationdb']['package_base_url']}/#{node['foundationdb']['version']}/foundationdb-clients_#{node['foundationdb']['version']}#{node['foundationdb']['dash_string']}"

  case node['platform_family']
  when 'debian'
    clients_source_url = "#{base_url}_amd64.deb"
  when 'rhel', 'fedora'
    clients_source_url = "#{base_url}.x86_64.rpm"
  end
end

clients_file = clients_source_url.split("/").last
clients_temp_file = "/tmp/#{clients_file}"

Chef::Log.info 'Installing FoundationDB client'
remote_file clients_temp_file do
  source clients_source_url
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
when 'rhel', 'fedora'
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
file clients_temp_file do
  action :delete
end
