default['ruby']['version'] = '2.0.0-p247'
default['ruby']['checksum'] = '3e71042872c77726409460e8647a2f304083a15ae0defe90d8000a69917e20d3'

default[:ruby][:prefix]         = "/usr/local"
default[:ruby][:configure_opts] = " --prefix='#{node[:ruby][:prefix]}' "
default[:ruby][:make_opts]      = '-j8'
