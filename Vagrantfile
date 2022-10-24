# -*- mode: ruby -*-
# vi: set ft=ruby :

IP_SRVR = "192.168.20.20"
i=1
IP_KIND = "192.168.20.#{i + 20}"

VAGRANTFILE_API_VERSION = "2"
BOX_IMAGE = "ubuntu/jammy64"
AUTOSTART = true

$dns_script = <<SCRIPT
echo "$1	kk8s.local	 kk8s" >> /etc/hosts
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

config.vm.define "kk8s", autostart: AUTOSTART	do |master|
		master.vm.box = BOX_IMAGE
        master.vm.boot_timeout = 900
		master.vm.hostname = 'kk8s.local'
		master.vm.network :private_network, ip: IP_SRVR
		master.vm.network :forwarded_port, guest: 22, host: 7722, id: "ssh"
    	master.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant"

		master.vm.provision "shell" do |s|
			s.inline = $dns_script
			s.args = [IP_SRVR]
		end

		master.vm.provision "shell", path: "script/setup.sh"
		master.vm.provision "shell", path: "script/setup-kube.sh"

		master.vm.provider :virtualbox do |vb|
					vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
					vb.customize ["modifyvm", :id, "--memory", 7777]
					vb.customize ["modifyvm", :id, "--name", "kk8s"]
					vb.customize ["modifyvm", :id, "--cpus", "2"]
		end
end

config.vm.define "kindk8s", autostart: AUTOSTART	do |node|
    node.vm.box = BOX_IMAGE
    node.vm.hostname = 'kindk8s.local'
    node.vm.network :private_network, ip: IP_KIND
    node.vm.network :forwarded_port, guest: 22, host: 7733, id: "ssh"
    node.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant"

    node.vm.provision "shell" do |s|
        s.inline = $dns_script
        s.args = [IP_KIND]
    end

    node.vm.provision "shell", path: "script/setup.sh"
    node.vm.provision "shell", path: "script/setup-kind.sh"
    node.vm.provision "shell", path: "script/setup-helm.sh"

    node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--memory", 5555]
                vb.customize ["modifyvm", :id, "--name", "kindk8s"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
end

end