#
# Cookbook Name:: ruby-src
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p374.tar.gz

package 'zlib1g-dev'
package 'libyaml-dev'
package 'libssl-dev'

remote_file "#{Chef::Config[:file_cache_path]}/ruby-#{node[:ruby][:version]}.tar.gz" do
  source "http://ftp.ruby-lang.org/pub/ruby/#{node[:ruby][:version][0..2]}/ruby-#{node[:ruby][:version]}.tar.gz"
  checksum node[:ruby][:checksum]
end

bash "install_ruby" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf ruby-#{node[:ruby][:version]}.tar.gz
    (cd ruby-#{node[:ruby][:version]}/ && ./configure && make -j8 && make install)
  EOH
  action :nothing
end

bash "ensure_ruby_install" do
  not_if "ruby -v | grep -q #{node[:ruby][:version].gsub('-', '')}"
  user "root"
  notifies :run, "bash[install_ruby]", :immediately
end

gem_package "bundler" do
  options(:prerelease => true)
end

if node[:ruby][:version].include?('2.0.0')
  # need to check out chef repo and build manually
  # current chef (3/12/13) bombs with rubygems 2.0
  git "#{Chef::Config[:file_cache_path]}/chef" do
    repository "git@github.com:opscode/chef.git"
    reference "CHEF-3935"
    action :checkout
    notifies :run, "bash[install_custom_chef]"
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
else
  gem_package "chef"
end
