#
# Cookbook Name:: foundationdb
# Recipe:: default
#
# Installs FoundationDB server.
#
# Copyright (c) 2014-2016, Kevin (penniesfromkevin)
#
# All rights reserved - Do Not Redistribute
#
require 'digest/md5'

# Client must be installed before server(!)
include_recipe 'foundationdb::client'

Chef::Log.info 'Installing FoundationDB server'
if node['foundationdb']['server_url']
  server_file = node['foundationdb']['server_url'].split("/").last
  server_temp_file = "/tmp/#{server_file}"

  remote_file server_temp_file do
    source node['foundationdb']['server_url']
    mode 00755
  end
else
  server_file = "foundationdb-server_#{node['foundationdb']['version']}-1_amd64.deb"
  server_temp_file = "/tmp/#{server_file}"

  if node['foundationdb']['base_url']
    remote_file server_temp_file do
      source "#{node['foundationdb']['base_url']}/#{server_file}"
      mode 00755
    end
  else
    cookbook_file server_file do
      path server_temp_file
      mode 00755
      action :create
    end
  end
end

# See if FoundationDB has been previously installed (fdb.cluster exists)
initial_install = File.exists?('/etc/foundationdb/fdb.cluster')

dpkg_package 'foundationdb-server' do
  options '--force-confold'
  source server_temp_file
  action [:install]
end

if node['foundationdb']['install_type'] == 'full' and not initial_install
  template '/etc/foundationdb/foundationdb.conf' do
    source 'foundationdb.conf.erb'
    owner node['foundationdb']['fdbmonitor']['user']
    group node['foundationdb']['fdbmonitor']['group']
    mode 0644
  end

  # Create new cluster files
  node['foundationdb']['processes'].each do |process|
    fdb_port = process['port']
    if process.has_key?(:id)
      process_id = process['id']
    else
      process_id = 'local'
    end
    if process.has_key?(:string)
      process_string = process['string']
    else
      process_string = 'fdbstring'
    end
    if process.has_key?(:file)
      file process['file'] do
        content "#{process_id}:#{process_string}@#{node['ipaddress']}:#{fdb_port}"
        owner node['foundationdb']['fdbmonitor']['user']
        group node['foundationdb']['fdbmonitor']['group']
        mode 00666
        action :create_if_missing
      end
    end
  end

  # Create log directories
  [
    node['foundationdb']['fdbserver']['datadir'],
    node['foundationdb']['fdbserver']['logdir'],
    node['foundationdb']['backup_agent']['logdir']
  ].each do |directory_location|
    directory directory_location do
      only_if { directory_location }
      owner node['foundationdb']['fdbmonitor']['user']
      group node['foundationdb']['fdbmonitor']['group']
      mode 00777
      recursive true
      action :create
    end
  end

  execute 'make public' do
    only_if { node['foundationdb']['make_public'] }
    command "/usr/lib/foundationdb/make_public.py #{node['foundationdb']['make_public_options']}"
    action :run
    # temporary until idempotency is implemented
    ignore_failure true
  end
end

# Delete temp files
file server_temp_file do
  action :delete
end
