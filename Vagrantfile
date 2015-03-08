# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = ENV['VAGRANT_BOX'] || "chef/centos-7.0"
  config.berkshelf.enabled = true

  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
  end

  config.vm.provision :chef_zero do |chef|
    chef.add_recipe 'mysql56::default'
  end
end
