# -*- mode: ruby -*-
# vi: set ft=ruby :


servers = [
    {
        :name => "k8s-head",
        :eth1 => "192.168.205.10",
        :mem => "2048",
        :cpu => "2"
    },
    {
        :name => "k8s-node-1",
        :eth1 => "192.168.205.11",
        :mem => "1024",
        :cpu => "1"
    }
]
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  servers.each do |opts|
    config.vm.define opts[:name] do |i|
      i.vm.provider "virtualbox" do |vb|
        vb.name = opts[:name]  
        # Customize the amount of memory on the VM:
        vb.memory = opts[:mem]
        vb.cpus = opts[:cpu]
      end

      i.vm.box = "centos/7"
      i.vm.hostname = opts[:name]
      i.vm.network :private_network, ip: opts[:eth1]
      i.ssh.forward_agent = true 
      i.vm.provision "file", source: "./setup.sh", destination: "."
      #config.vm.provision "shell", path: "setup.sh"
    end

  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
end