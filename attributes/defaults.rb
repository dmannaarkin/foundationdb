#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# Installations can be full or upgrade only (does not touch configurations)
#default['foundationdb']['install_type'] = 'upgrade'
default['foundationdb']['install_type'] = 'full'

# Options
default['foundationdb']['options'] = [
  {
    'name' => 'fdbmonitor',
    'options' => {
      'user' => 'foundationdb',
      'group' => 'foundationdb'
    }
  },
  {
    'name' => 'general',
    'options' => {
      'restart_delay' => 60,
      'cluster_file' => '/etc/foundationdb/fdb.cluster'
    }
  },
  {
    'name' => 'fdbserver',
    'options' => {
      'command' => '/usr/sbin/fdbserver',
      'public_address' => 'auto:$ID',
      'listen_address' => 'public',
      'datadir' => '/mnt/fdb/$ID',
      'logdir' => '/mnt/logs/fdb',
      '# logsize' => '10MiB',
      '# maxlogssize' => '100MiB',
      '# machine_id' => '',
      '# datacenter_id' => '',
      '# class' => '',
      '# memory' => '8GiB',
      '# storage_memory' => '1GiB'
    }
  },
  {
    'name' => 'backup_agent',
    'options' => {
      'command' => '/usr/lib/foundationdb/backup_agent/backup_agent'
    }
  }
]

# ssd processes
default['foundationdb']['processes'] = [
  {
    'port' => 4500
  }
]

# Optional datacenter ID and machine ID
default['foundationdb']['datacenter_id'] = nil
default['foundationdb']['machine_id'] = nil

# These will change the default locations
default['foundationdb']['data_dir'] = nil
default['foundationdb']['log_dir'] = nil

# Explicit package URLs, if available; if these are provided, version and
#   base_url are ignored.
default['foundationdb']['clients_url'] = nil
default['foundationdb']['server_url'] = nil

# Manage the versions if explicit package URLs have not been provided.
default['foundationdb']['version'] = '2.0.10'

# Base URL for packages, if available; path up to, but not including, slash
default['foundationdb']['base_url'] = nil

default['foundationdb']['make_public'] = true
# When make_public accepts different options, they can be specified here
default['foundationdb']['make_public_options'] = ''
