nodes = [
  { :hostname => "graylog01", :memory => 4096, :cpu => 2, :private_ip => "192.168.1.11", :disksize => "50GB", :boxname => "ubuntu/focal64" },
  { :hostname => "graylog02", :memory => 4096, :cpu => 2, :private_ip => "192.168.1.12", :disksize => "50GB",:boxname => "ubuntu/focal64" },
  { :hostname => "graylog03", :memory => 4096, :cpu => 2, :private_ip => "192.168.1.13", :disksize => "50GB", :boxname => "ubuntu/focal64" },
  { :hostname => "mgmt-ansible", :memory => 1024, :cpu => 1, :private_ip => "192.168.1.14", :disksize => "50GB", :boxname => "ubuntu/focal64" }
 
]

Vagrant.configure("2") do |config|
  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("C:\\Users\\ohrynkov\\.ssh\\id_rsa.pub").first.strip
    s.inline = <<-SHELL
    echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
    echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
    SHELL
  end

  nodes.each do |node|
    config.vm.box_check_update = false
    config.ssh.insert_key = false
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:boxname]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.disksize.size = node[:disksize]
      nodeconfig.vm.network :private_network, ip: node[:private_ip]
      # if node[:hostname] =! "mgmt-ansible"
      #   nodeconfig.vm.network "public_network", bridge: "Intel(R) Dual Band Wireless-AC 8265"
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpu]
      end

      # Provision Ansible only on mgmt-ansible node
      if node[:hostname] == "mgmt-ansible"
        #nodeconfig.vm.provision "shell", path: "provision.sh"
        nodeconfig.vm.provision "file", source: "C:\\Users\\ohrynkov\\.ssh\\id_rsa", destination: "host_ssh_private_key"
        nodeconfig.vm.provision "shell", inline: <<-SHELL
          cat host_ssh_private_key > /home/vagrant/.ssh/id_rsa 
        SHELL
        nodeconfig.vm.provision "ansible_local" do |ansible|
          ansible.compatibility_mode = "2.0"
          ansible.playbook = "playbook.yml"
          ansible.limit = "all" 
          ansible.config_file = "ansible.cfg"
          ansible.inventory_path = "inventory"
          ansible.galaxy_roles_path = "/vagrant/roles"
          #ansible.galaxy_role_file = "roles_requirements.yml"
        end
        nodeconfig.vm.provision "shell", inline: "cat /vagrant/ansible.cfg > /etc/ansible/ansible.cfg"
      end
    end
  end
end