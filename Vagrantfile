# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Base box
  config.vm.box = "a-h/oracle_linux_7"
  config.vm.box_check_update = false

  # Network configuration
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  # Provisioning
  config.vm.provision "system", type: "shell", path: 'provision_system.sh'
  config.vm.provision "oracle", type: "shell", path: 'provision_oracle.sh'
end
