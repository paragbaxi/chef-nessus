nessus Cookbook
===============
This cookbook installs [Tenable Nessus](http://www.tenable.com/products/nessus)
and does some initial setup. Currently it can enable the service and
activate your feed subscription.

Requirements
------------

Tenable does not currently offer direct download of the Nessus installer
so currently we have to rely on it being somewhere on the filesystem.
This can be accomplished with another cookbook, shared directory, etc.

Attributes
----------

 * installer_file - Where to find the installer file.
 * enable - Boolean - Whether to enable/start the service
 * activate - Boolean - Whether to activate the subscription
 * activation_code - String - Nessus Feed activation code

Usage
-----
#### nessus::default

Just include `nessus` in your node's `run_list` to install and start:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nessus]"
  ]
}
```

To activate as well:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nessus]"
  ],
  "default_attributes": {
    "nessus":{
      "installer_file":"/vagrant/installers/Nessus-*",
      "activation_code":"FFFF-AAAA-BBBB-CCCC-DDDD"
    }
  }
}
```

#### nessus::users

Will automatically be included if you configure a `chef-vault` item
with Nessus users.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nessus]"
  ],
  "default_attributes": {
    "nessus":{
      "installer_file":"/vagrant/installers/Nessus-*",
      "activation_code":"FFFF-AAAA-BBBB-CCCC-DDDD"
      "vault":"nessus",
      "vault_users_item":"users"
    }
  }
}
```

Creating the vault might look something like this:
```
bin/knife vault create nessus users \
 '{"bob":"thebuilder","diego":"theDESTROYER"}' \ 
 --search "role:some_role" \
 --admin some_guy
```

With each pair being `user:password`.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Forked from Jason Rohwedder <jro@risk.io>
