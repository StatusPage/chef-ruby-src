
default[:ruby][:version] = '2.0.0-p0'
default[:ruby][:checksum] = 'aff85ba5ceb70303cb7fb616f5db8b95ec47a8820116198d1c866cc4fff151ed'

default[:ruby][:prefix]         = "/usr/local"
default[:ruby][:configure_opts] = " --prefix='#{node[:ruby][:prefix]}' "
default[:ruby][:make_opts]      = '-j8'
