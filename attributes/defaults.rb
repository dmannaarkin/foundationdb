#
# Copyright (c) 2014-2015, Kevin (penniesfromkevin)
#
# Installations can be full or upgrade only (does not touch configurations)
#default['foundationdb']['install_type'] = 'upgrade'
default['foundationdb']['install_type'] = 'full'

# Manage the versions
default['foundationdb']['version'] = '2.0.10'
default['foundationdb']['dash_string'] = '-1'

# ssd processes
default['foundationdb']['processes'] = [
  {
    'port' => 4500
  }
]

# Optional datacenter ID
default['foundationdb']['datacenter_id'] = nil

default['foundationdb']['make_public'] = true
# When make_public accepts different options, they can be specified here
default['foundationdb']['make_public_options'] = ''

# These will change the default locations
default['foundationdb']['data_dir'] = nil
default['foundationdb']['log_dir'] = nil

# cleanup removes any temporary files that were needed to set up the new version (.rpm files, .deb files, etc.)
default['foundationdb']['cleanup'] = true
default['foundationdb']['temp_dir'] = '/tmp'
