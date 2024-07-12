nodes = [
  { :hostname => "slave-node-1", :memory => 1024, :cpu => 1, :private_ip => "192.168.1.1", :boxname => "ubuntu/focal64" },
  { :hostname => "slave-node-2", :memory => 1024, :cpu => 1, :private_ip => "192.168.1.2", :boxname => "ubuntu/focal64" },
  { :hostname => "primary-node", :memory => 1024, :cpu => 1, :private_ip => "192.168.1.3", :boxname => "ubuntu/focal64" },
  { :hostname => "mgmt-ansible", :memory => 1024, :cpu => 1, :private_ip => "192.168.1.4", :boxname => "ubuntu/focal64" }
 
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
      nodeconfig.vm.network :public_network, bridge: "Intel(R) Dual Band Wireless-AC 8265"
      nodeconfig.vm.network :private_network, ip: node[:private_ip]
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.memory = node[:memory]
        vb.cpus = node[:cpu]
      end

      # Provision Ansible only on mgmt-ansible node
      if node[:hostname] == "mgmt-ansible"
         nodeconfig.vm.provision "shell", path: "provision.sh"
         nodeconfig.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "playbook.yml"
          ansible.install_mode = "pip_args_only"
          ansible.pip_install_cmd = "sudo ln -s -f /usr/bin/pip3 /usr/bin/pip"
          ansible.pip_args = "ansible==2.10.1"
          ansible.verbose = true
          ansible.install = true
          ansible.limit = "all" 
          ansible.inventory_path = "inventory"
          ansible.groups = {
            "graylog" => ["slave-node-1","slave-node-2","primary-node"]
          }
        end
      end
    end
  end
end