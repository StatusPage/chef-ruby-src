ruby-src Cookbook
====================
Basic cookbook to install ruby from src on Ubuntu 12.04 LTS

Requirements
------------
Only tested on Ubuntu 12.04, but since compiling from src it should work on other platforms.

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
    <td>sha256 checksum of the .tar.gz bundle containing the source of the version specified above</td>
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

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Scott Klein <scott@statuspage.io>
