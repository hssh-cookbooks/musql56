#
# Cookbook Name:: mysql56
# Recipe:: default
#
# The MIT License (MIT)
# 
# Copyright (c) 2015 Hisashi KOMINE
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if node['platform'] == 'centos'
  # Disable SELinux
  selinux 'disabled' do
  end

  execute 'yum-install-mysql-community' do
    command 'yum install -y http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm'
    not_if { File.exist? '/etc/yum.repos.d/mysql-community.repo' }
  end

  package 'mysql-community-server' do
  end

  service 'mysql' do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
elsif node['platform'] == 'ubuntu'
  remote_file '/root/mysql-apt-config_0.3.3-1ubuntu14.04_all.deb' do
    source 'http://dev.mysql.com/get/mysql-apt-config_0.3.3-1ubuntu14.04_all.deb'
    action :create_if_missing
  end

  cookbook_file '/root/preseed.cfg' do
    notifies :run, 'execute[debconf-set-selections /root/preseed.cfg]', :immediately
  end
  execute 'debconf-set-selections /root/preseed.cfg' do
    action :nothing
  end

  execute 'install-mysql-apt-config' do
    environment 'DEBIAN_FRONTEND' => 'noninteractive'
    command <<-EOC
      dpkg -i /root/mysql-apt-config_0.3.3-1ubuntu14.04_all.deb
      apt-get update
    EOC
    not_if 'dpkg -l | grep -q mysql-apt-config'
  end

  %w(
  mysql-server
  mysql-utilities
  ).each do |p|
    package p do
    end
  end

  service 'mysql' do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
end