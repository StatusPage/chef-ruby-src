#
# Cookbook Name:: ruby-src
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p374.tar.gz


packages = value_for_platform_family(
             "rhel" => ["openssl-devel","zlib-devel","readline-devel", "libyaml-devel"],
             "default" => ["libssl-dev","zlib1g-dev","libreadline-dev", "libyaml-dev"]
           )

packages.each do |dev_pkg|
  package dev_pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/ruby-#{node[:ruby][:version]}.tar.gz" do
  # Include a not_if to prevent download on a bootstrap where the ruby version already
  # matches or when running under chef-solo (which deletes the tar file). Checksum will
  # handle things from there.
  not_if "#{node[:ruby][:prefix]}/bin/ruby -v | grep \"#{node[:ruby][:version].gsub('-', '')}\""
  source "http://ftp.ruby-lang.org/pub/ruby/#{node[:ruby][:version][0..2]}/ruby-#{node[:ruby][:version]}.tar.gz"
  checksum node[:ruby][:checksum]
end

bash "install_ruby" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar --no-same-owner -zxf ruby-#{node[:ruby][:version]}.tar.gz
    (cd ruby-#{node[:ruby][:version]}/ && ./configure #{node[:ruby][:configure_opts]} && make #{node[:ruby][:make_opts]} && make install)
  EOH
  action :nothing
end

bash "ensure_ruby_install" do
  not_if "#{node[:ruby][:prefix]}/bin/ruby -v | grep \"#{node[:ruby][:version].gsub('-', '')}\""
  user "root"
  notifies :run, "bash[install_ruby]", :immediately
  notifies :install, "gem_package[bundler]", :immediately
  notifies :install, "gem_package[foreman]", :immediately
  notifies :install, "gem_package[chef]", :immediately
end

gem_package "bundler" do
  options('--pre')
  action :nothing
end

gem_package "foreman" do
  action :nothing
end

gem_package "chef" do
  action :nothing
end
