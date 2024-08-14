nodes = [
  { :hostname => "graylog01", :memory => 4096, :cpu => 2, :private_ip => "192.168.1.15", :disksize => "50GB", :boxname => "ubuntu/focal64" },
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
      config.vm.synced_folder '.', '/vagrant', disabled: true
      nodeconfig.vm.box = node[:boxname]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.disksize.size = node[:disksize]
      nodeconfig.vm.network :private_network, ip: node[:private_ip]
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpu]
      end

      # Provision Ansible only on mgmt-ansible node
      if node[:hostname] == "mgmt-ansible"
        #nodeconfig.vm.provision "shell", path: "provision.sh"
        nodeconfig.vm.network :private_network, ip: node[:private_ip]
        config.vm.synced_folder '.', '/vagrant', disabled: false
        nodeconfig.vm.provision "file", source: "C:\\Users\\ohrynkov\\.ssh\\id_rsa", destination: "host_ssh_private_key"
        nodeconfig.vm.provision "shell", inline: <<-SHELL
          echo "export ANSIBLE_CONFIG='/vagrant/ansible.cfg'" >> /etc/profile.d/myvar.sh
          cat host_ssh_private_key > /home/vagrant/.ssh/id_rsa 
        SHELL
        nodeconfig.vm.provision "ansible_local" do |ansible|
          ansible.compatibility_mode = "2.0"
          ansible.playbook = "playbook.yml"
          ansible.limit = "all" 
          ansible.config_file = "/vagrant/ansible.cfg"
          ansible.inventory_path = "/vagrant/inventory/inventory.ini"
          ansible.galaxy_roles_path = "/vagrant/roles"
        end
      end
    end
  end
end