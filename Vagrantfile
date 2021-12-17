Vagrant.configure("2") do |config|
  config.vm.define "psql1" do |psql1|
    psql1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    psql1.vm.box = "ubuntu/focal64"
    psql1.vm.hostname = "psql1"
    #boundary1.vm.network "public_network"
    psql1.vm.network :private_network, ip: "192.168.56.4"
    psql1.vm.box_check_update = true
    psql1.vm.synced_folder "provision", "/provision"
    psql1.vm.provision "shell", path: "provision/basic_setup.sh"
    psql1.vm.provision "shell", path: "provision/install_postgres.sh"
  end

  config.vm.define "boundary1" do |boundary1|
    boundary1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    boundary1.vm.box = "ubuntu/focal64"
    boundary1.vm.hostname = "boundary1"
    #boundary1.vm.network "public_network"
    boundary1.vm.network :private_network, ip: "192.168.56.2"
    boundary1.vm.box_check_update = true
    boundary1.vm.synced_folder "provision", "/provision"
    boundary1.vm.provision "shell", path: "provision/basic_setup.sh"
    boundary1.vm.provision "shell", path: "provision/install_boundary.sh"
  end

  config.vm.define "vault1" do |vault1|
    vault1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    vault1.vm.box = "ubuntu/focal64"
    vault1.vm.hostname = "vault1"
    #vault1.vm.network "public_network"
    vault1.vm.network :private_network, ip: "192.168.56.3"
    vault1.vm.box_check_update = true
    vault1.vm.synced_folder "provision", "/provision"
    vault1.vm.provision "shell", path: "provision/basic_setup.sh"
    vault1.vm.provision "shell", path: "provision/install_vault.sh"
  end

  config.vm.define "boundaryworker1" do |boundaryworker1|
    boundaryworker1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    boundaryworker1.vm.box = "ubuntu/focal64"
    boundaryworker1.vm.hostname = "boundaryworker1"
    #boundaryworker1.vm.network "public_network"
    boundaryworker1.vm.network :private_network, ip: "192.168.56.5"
    boundaryworker1.vm.box_check_update = true
    boundaryworker1.vm.synced_folder "provision", "/provision"
    boundaryworker1.vm.provision "shell", path: "provision/basic_setup.sh"
    boundaryworker1.vm.provision "shell", path: "provision/install_boundary_worker.sh"
  end

#  config.vm.define "bastion1" do |bastion1|
#    bastion1.vm.provider "virtualbox" do |v|
#      v.memory = 1024
#      v.cpus = 1
#    end
#    bastion1.vm.box = "ubuntu/focal64"
#    bastion1.vm.hostname = "bastion1"
#    #boundaryworker1.vm.network "public_network"
#    bastion1.vm.network :private_network, ip: "192.168.56.6"
#    bastion1.vm.box_check_update = true
#    bastion1.vm.synced_folder "provision", "/provision"
#    bastion1.vm.provision "shell", path: "provision/basic_setup.sh"
#  end
end