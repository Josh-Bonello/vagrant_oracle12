# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

Vagrant.configure(2) do |config|
  # Base box
  config.vm.box = "a-h/oracle_linux_7"
  config.vm.box_check_update = false

  # Network configuration
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant_oracle"
    vb.cpus = 2
    vb.memory = "4096"

    # Get disk path
    extra_disk = File.join(VAGRANT_ROOT, 'extra.vdi')

    # Create and attach disk
    unless File.exist?(extra_disk)
      vb.customize ['createhd', '--filename', extra_disk, '--format', 'VDI', '--size', 100 * 1024]
    end
    vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'hdd', '--medium', extra_disk]
  end

  # Provisioning
  config.vm.provision "system", type: "shell", path: 'provision_system.sh'
  config.vm.provision "oracle", type: "shell", path: 'provision_oracle.sh'
end

