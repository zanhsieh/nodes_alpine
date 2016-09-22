# -*- mode: ruby -*-
# vi: set ft=ruby :

$IPs = {
  "nodejs-alpine"   => "10.9.8.7",
}

def host_check(ips={})
  return ips.map {|k,v|<<-INNER
  if [ ! `grep -q #{v} /etc/hosts` ]; then
    echo '#{v} #{k}' | sudo tee -a /etc/hosts
  fi
  INNER
  }.join()
end

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-jessie64"
  config.vm.box_check_update = false
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = "box"
    config.cache.synced_folder_opts = {
      type: "nfs",
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end
  $IPs.map do |k,v|
    config.vm.define "#{k}" do |m|
      m.vm.hostname = "#{k}"
      m.vm.network "private_network", ip: "#{v}"
      m.vm.provision "shell", inline:<<-SHELL
      #{host_check($IPs)}
      SHELL
      m.vm.provision "shell", path: "setup_docker.sh"
      m.vm.provision "shell", path: "build.sh"
    end
  end
end
