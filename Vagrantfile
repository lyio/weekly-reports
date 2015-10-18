# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
 	config.vm.box = "hashicorp/precise64"
	config.vm.provision :shell, path: "setup/bootstrap.sh"
	config.vm.provision :shell, path: "setup/install-rvm.sh", args: "stable", privileged: false
 	config.vm.provision :shell, path: "setup/install-ruby.sh", args: "2.2.1", privileged: false
	config.vm.provision :shell, path: "setup/start.sh", privileged: false
	config.vm.network :forwarded_port, guest: 4000, host: 9000
	config.vm.network :forwarded_port, guest: 9292, host: 9001
end
	
