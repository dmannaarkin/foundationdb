#
# Copyright (c) 2014-2016, Kevin (penniesfromkevin)
#
# Installations can be full or upgrade only (does not touch configurations)
#default['foundationdb']['install_type'] = 'upgrade'
default['foundationdb']['install_type'] = 'full'

# Options
default['foundationdb']['fdbmonitor']['user'] = 'foundationdb'
default['foundationdb']['fdbmonitor']['group'] = 'foundationdb'

default['foundationdb']['general']['restart_delay'] = 10
default['foundationdb']['general']['cluster_file'] = '/etc/foundationdb/fdb.cluster'

default['foundationdb']['fdbserver']['command'] = '/usr/sbin/fdbserver'
default['foundationdb']['fdbserver']['public_address'] = 'auto:$ID'
default['foundationdb']['fdbserver']['listen_address'] = 'public'
default['foundationdb']['fdbserver']['datadir'] = '/mnt/fdb/$ID'
default['foundationdb']['fdbserver']['logdir'] = '/mnt/logs/fdb'
default['foundationdb']['fdbserver']['logsize'] = nil  # '10MiB'
default['foundationdb']['fdbserver']['maxlogssize'] = nil  # '100MiB'
default['foundationdb']['fdbserver']['machine_id'] = nil
default['foundationdb']['fdbserver']['datacenter_id'] = nil
default['foundationdb']['fdbserver']['class'] = nil
default['foundationdb']['fdbserver']['memory'] = nil  # '8GiB'
default['foundationdb']['fdbserver']['storage_memory'] = nil  # '1GiB'
default['foundationdb']['fdbserver']['knobs'] = {}

default['foundationdb']['backup_agent']['command'] = '/usr/lib/foundationdb/backup_agent/backup_agent'
default['foundationdb']['backup_agent']['logdir'] = '/mnt/logs/fdb'

# ssd processes
default['foundationdb']['processes'] = [
  {
    'port' => 4500
  }
]
# Sample full process options:
# {
#   'id' => 'buffer',
#   'port' => 4600,
#   'file' => '/etc/foundationdb/memory.cluster',
#   'class' => 'transaction',
#   'memory' => 22,
#   'storage_memory" => 13,
#   'count' => 1
# }

# Explicit package URLs, if available; if these are provided, version and
#   base_url are ignored.
default['foundationdb']['clients_url'] = nil
default['foundationdb']['server_url'] = nil
# Manage the versions if explicit package URLs have not been provided.
default['foundationdb']['version'] = '3.0.10'
# Base URL for packages, if available; path up to, but not including, slash
default['foundationdb']['base_url'] = nil

default['foundationdb']['make_public'] = true
# When make_public accepts different options, they can be specified here
default['foundationdb']['make_public_options'] = ''
