#
# Cookbook Name:: foundationdb
# Recipe:: default
#
# Installs FoundationDB server.
#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# All rights reserved - Do Not Redistribute
#
# Client must be installed before server(!)
include_recipe 'wavefront::client'
server_temp_file = "#{node['foundationdb']['temp_dir']}/#{node['foundationdb']['server_file'][node['platform_family']]}"

Chef::Log.info 'Installing FoundationDB server'
remote_file server_temp_file do
  source node['foundationdb']['server_source_url'][node['platform_family']]
  owner 'root'
  group 'root'
  mode 00755
end

# See if FoundationDB has been previously installed (fdb.cluster exists)
initial_file = '/etc/foundationdb/fdb.cluster'
if File.exists?(initial_file)
  initial_install = false
else
  initial_install = true
end

case node['platform_family']
when 'debian'
  dpkg_package 'foundationdb-server' do
    source server_temp_file
    action [:install]
  end
when 'rhel', 'fedora'
  rpm_package 'foundationdb-server' do
    source server_temp_file
    action [:install]
  end
end

if node['foundationdb']['install_type'] == 'full'
  execute 'Make /etc/foundationdb writable by all' do
    command 'chmod 777 /etc/foundationdb'
    action :run
  end

  # Other server options
  foundationdb_conf = '/etc/foundationdb/foundationdb.conf'

  if node['foundationdb']['data_dir']
    Chef::Log.info 'Configuring FoundationDB data_dir'
    directory node['foundationdb']['data_dir'] do
      owner 'foundationdb'
      group 'foundationdb'
      mode 00777
      recursive true
      action :create
    end

    ruby_block 'Edit foundationdb.conf data_dir' do
      block do
        rc = Chef::Util::FileEdit.new(foundationdb_conf)
        rc.search_file_replace_line("^datadir = /var/lib/foundationdb/data/.*", "datadir = #{node['foundationdb']['data_dir']}/$ID")
        rc.write_file
      end
    end
  end

  if node['foundationdb']['log_dir']
    Chef::Log.info 'Configuring FoundationDB log_dir'
    directory node['foundationdb']['log_dir'] do
      owner 'foundationdb'
      group 'foundationdb'
      mode 00777
      recursive true
      action :create
    end

    ruby_block 'Edit foundationdb.conf log_dir' do
      block do
        rc = Chef::Util::FileEdit.new(foundationdb_conf)
        rc.search_file_replace_line('^logdir = /var/log/foundationdb', "logdir = #{node['foundationdb']['log_dir']}")
        rc.write_file
      end
    end
  end

  if node['foundationdb']['datacenter_id']
    ruby_block 'Edit foundationdb.conf datacenter_id' do
      block do
        rc = Chef::Util::FileEdit.new(foundationdb_conf)
        rc.search_file_replace_line('# datacenter_id =.*', 'datacenter_id = ')
        rc.write_file
        rc.search_file_replace_line('datacenter_id =.*', "datacenter_id = #{node['foundationdb']['datacenter_id']}")
        rc.write_file
      end
    end
  end

  if node['foundationdb']['processes']
    # Comment out the initial process; user may not want 4500
    ruby_block 'Edit foundationdb.conf fdbserver.port' do
      block do
        rc = Chef::Util::FileEdit.new(foundationdb_conf)
        rc.search_file_replace_line("^.fdbserver\.4500.", "#[fdbserver.4500]")
        rc.write_file
      end
    end
  end

  # Create new processes
  node['foundationdb']['processes'].each do |process|
    fdb_port = process['port']
    if process.has_key?(:count)
      fdb_count = process['count']
    else
      fdb_count = 1
    end
    process_options = ''
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
      # Processes with files are usually memory processes
      file process['file'] do
        content "#{process_id}:#{process_string}@#{node['ipaddress']}:#{fdb_port}"
        owner 'foundationdb'
        group 'foundationdb'
        mode 00666
        action :create_if_missing
      end
      process_options += "\ncluster_file = #{process['file']}"
    elsif initial_install and not process.has_key?(:class)
      # Processes without files are SSD processes
      file initial_file do
        content "#{process_id}:#{process_string}@#{node['ipaddress']}:#{fdb_port}"
        owner 'foundationdb'
        group 'foundationdb'
        mode 00666
        action :create
      end
      # Only do this once
      initial_install = false
    end
    if process.has_key?(:memory)
      process_options += "\nmemory = #{process['memory']}GiB"
    end
    if process.has_key?(:storage_memory)
      process_options += "\nstorage_memory = #{process['storage_memory']}GiB"
    end
    if process.has_key?(:class)
      process_options += "\nclass = #{process['class']}"
    end
    ruby_block "Edit foundationdb.conf for process settings #{fdb_port}" do
      block do
        (1..fdb_count).each do|i|
          rc = Chef::Util::FileEdit.new(foundationdb_conf)
          rc.insert_line_if_no_match("^.fdbserver\.#{fdb_port}.", "\n# Process port #{fdb_port}\n[fdbserver.#{fdb_port}]#{process_options}")
          rc.write_file
          fdb_port += 1
        end
      end
    end
  end

  if node['foundationdb']['make_public']
    Chef::Log.info 'Making FoundationDB node public'
    execute 'make public' do
      command "/usr/lib/foundationdb/make_public.py #{node['foundationdb']['make_public_options']}"
      action :run
      # temporary until idempotency is implemented
      ignore_failure true
    end
  end
end

# Delete temp files
if node['foundationdb']['cleanup']
  file server_temp_file do
    action :delete
  end
end
