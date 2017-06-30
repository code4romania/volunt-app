# -*- mode: ruby -*-
# vi: set ft=ruby :
system('ansible-galaxy install -p ansible/roles/external -r ansible/roles/external.yml')

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Official ubuntu/xenial64 box comes with a ubuntu user and
  # doesn't have a vagrant user
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.hostname = "comunitate"
  config.vm.network :private_network, type: "dhcp"
  config.vm.network "forwarded_port", guest: 3000, host: 8000
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--name", "comunitate", "--memory", "1024"]
  end

  config.vm.synced_folder "../volunt-app", "/var/www/volunt-app"
  config.ssh.private_key_path = [
    "~/.vagrant.d/insecure_private_key",
    "~/.ssh/id_rsa"
  ]
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Ansible provisioner.
  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
        "development" => ["default"]
    }
    ansible.playbook = "ansible/vagrant.yml"
    ansible.host_key_checking = false
    ansible.raw_arguments = ["--timeout=100"]
  end
end
