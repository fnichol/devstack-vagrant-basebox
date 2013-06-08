# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.hostname = "devstack"

  config.vm.provider "vmware_fusion" do |p|
    p.vmx["memsize"] = "2048"
  end

  config.vm.provider "virtualbox" do |p|
    p.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.network :private_network, ip: "33.33.33.33"

  config.vm.provision :shell, :path => "prep_devstack.sh"
end
