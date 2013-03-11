ruby-src Cookbook
====================
Basic cookbook to install ruby from src on Ubuntu 12.04 LTS

Requirements
------------
Only tested on Ubuntu 12.04, but since compiling from src it should work on other platforms.

Depends on ```build-essential``` cookbook distributed by Opscode.

Attributes
----------
#### ruby-src::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['ruby']['version']</tt></td>
    <td>String</td>
    <td>name fo the ruby version to be installed</td>
  </tr>
  <tr>
    <td><tt>['ruby']['checksum']</tt></td>
    <td>String</td>
    <td>sha256 checksum of the .tar.gz source bundle</td>
  </tr>
</table>

Usage
-----
#### ruby-src::default

Just include `ruby-src` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ruby-src]"
  ]
}
```

License and Authors
-------------------
Authors: Scott Klein <scott@statuspage.io>
