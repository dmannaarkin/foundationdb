foundationdb Cookbook
=====================
This cookbook installs and configure FoundationDB.

Requirements
------------
If FoundationDB packages are not provided via URLs, they must be added to the
repository in <root>/files/default/.
The names of the files should resemble:
- foundationdb-clients_2.0.10-1_amd64.deb
- foundationdb-server_2.0.10-1_amd64.deb

Attributes
----------
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['foundationdb']['role']</tt></td>
    <td>String</td>
    <td>Install server or client. Possible values: client, server</td>
    <td><tt>'server'</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['install_type']</tt></td>
    <td>String</td>
    <td>Full installation (configurations as well) or upgrade.
        Possible values: full, upgrade</td>
    <td><tt>'full'</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['version']</tt></td>
    <td>String</td>
    <td>FoundationDB version to install.  There will soon be support for the
        value 'latest', but not today ):</td>
    <td><tt>'2.0.10'</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['data_dir']</tt></td>
    <td>String or nil</td>
    <td>Path to data directory for storage.  A value of <tt>nil</tt> will
        result in the FoundationDB default location.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['log_dir']</tt></td>
    <td>String or nil</td>
    <td>Path to directory for logs.  A value of <tt>nil</tt> will
        result in the FoundationDB default location.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['datacenter_id']</tt></td>
    <td>Hexadecimal String or nil</td>
    <td>16-character hexadecimal string denoting the datacenter ID.  A value
        of nil will leave this parameter unset.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['processes']</tt></td>
    <td>List of dictionaries</td>
    <td>Only 'port' is required. Format:<br />
      <pre>
[
  {
    'port' => 4500,
    'id' => 'string',
    'file' => '/etc/foundationdb/file.cluster',
    'memory' => 24,
    'storage_memory' => 16,
    'count' => 1
  },
  .
  .
  {
    ..
  }
]
      </pre>
    </td>
    <td><pre>
[
  {
    'port' => 4500
  }
]
    </tt></pre>
  </tr>
  <tr>
    <td><tt>['foundationdb']['base_url']</tt></td>
    <td>String</td>
    <td>URL base path from which the FoundationDB packages can be downloaded.
        This makes it easier to specify private locations if the files are
        being managed internally.</td>
    <td><tt>'https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement'</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['make_public']</tt></td>
    <td>Boolean</td>
    <td>Run make_public after installation.  Possible values: true, false</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['cleanup']</tt></td>
    <td>Boolean</td>
    <td>When true, removes any temporary files that were needed to set up the
        new version (.rpm files, .deb files, etc.).</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foundationdb']['temp_dir']</tt></td>
    <td>Path String</td>
    <td>Location for temporary files needed to install FoundationDB.</td>
    <td><tt>/tmp</tt></td>
  </tr>
</table>
There are other parameters that are being moved internal so that users
will not have to worry about them.

Usage
-----
Just include `foundationdb` in your node's `run_list`:
```json
{
  "name": "my_node",
  "run_list": [
    "recipe[foundationdb]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
  Kevin (penniesfromkevin)
