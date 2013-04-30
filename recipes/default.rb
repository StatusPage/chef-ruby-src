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
  source "http://ftp.ruby-lang.org/pub/ruby/#{node[:ruby][:version][0..2]}/ruby-#{node[:ruby][:version]}.tar.gz"
  checksum node[:ruby][:checksum]
end

bash "install_ruby" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf ruby-#{node[:ruby][:version]}.tar.gz
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

  if node[:ruby][:version].include?('2.0.0')
    # need to check out chef repo and build manually
    # current chef (3/12/13) bombs with rubygems 2.0
    notifies :checkout, "git[#{Chef::Config[:file_cache_path]}/chef]", :immediately
  else
    notifies :install, "gem_package[chef]", :immediately
  end
end

gem_package "bundler" do
  options('--pre')
  action :nothing
end

gem_package "foreman" do
  action :nothing
end

git "#{Chef::Config[:file_cache_path]}/chef" do
  repository "https://github.com/opscode/chef"
  reference "CHEF-3935"
  action :checkout
  notifies :run, "bash[install_custom_chef]", :immediately
  action :nothing
end

bash "install_custom_chef" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/chef"
  code <<-EOH
    gem build chef.gemspec
    gem install chef-11.4.0.gem --no-ri --no-rdoc
  EOH
  action :nothing
end

gem_package "chef" do
  action :nothing
end
