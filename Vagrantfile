# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.forward_port 3000, 3100
  config.vm.forward_port 27017, 27018
  config.vm.share_folder "project-folder", "/home/vagrant/project", "project", 
  	:create => true
  	
  config.vm.host_name = 'mongo'
  config.vm.share_folder "mongodb", "/tmp/vagrant-puppet/modules/mongodb", "."
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "default.pp"
    puppet.options = ["--modulepath", "/tmp/vagrant-puppet/modules"]
  end
end
