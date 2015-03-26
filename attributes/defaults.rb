#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# Installations can be full or upgrade only (does not touch configurations)
#default['foundationdb']['install_type'] = 'upgrade'
default['foundationdb']['install_type'] = 'full'

# ssd processes
default['foundationdb']['processes'] = [
  {
    'port' => 4500
  }
]

# Optional datacenter ID
default['foundationdb']['datacenter_id'] = nil

# These will change the default locations
default['foundationdb']['data_dir'] = nil
default['foundationdb']['log_dir'] = nil

# Explicit package URLs, if available
default['foundationdb']['clients_url'] = nil
default['foundationdb']['server_url'] = nil

default['foundationdb']['make_public'] = true
# When make_public accepts different options, they can be specified here
default['foundationdb']['make_public_options'] = ''

# Manage the versions if explicit package URLs have not been provided.
default['foundationdb']['version'] = '2.0.10'
