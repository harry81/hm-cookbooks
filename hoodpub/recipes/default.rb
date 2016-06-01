#
# Cookbook Name:: hoodpub
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
#

package "git"
package "python-virtualenv"
package "python-jpype"
package "tmux"
package "uwsgi"
package "nginx"
package "uwsgi-plugin-python"
package "g++"
package "python-dev"
package "libffi-dev"
package "zsh"
package "libxml2-dev"
package "libxslt1.1"
package "libncurses-dev"
package "libpq-dev"
package "python-imaging"

user node.hoodpub.deploy do
  comment 'hoodpub user'
  home node.hoodpub.deploy_path
  uid '1234'
  shell '/bin/zsh'
  supports :manage_home => true
  password '$1$077OG8Lh$iarEmNtv.2wybHMPNDgr81'
  action :create
end

directory node.hoodpub.src_path do
  owner node.hoodpub.deploy
  group node.hoodpub.deploy
  mode "0755"
  recursive true
  action :create
end

template '/home/deploy/.zshrc' do
  source 'zshrc.erb'
  owner 'deploy'
  mode '0644'
end

template '/etc/nginx/sites-available/hoodpub_conf.nginx' do
  source 'hoodpub_conf_nginx.erb'
  owner 'deploy'
  mode '0644'
end

bash "link nginx conf" do
  user "root"
  code <<-BASH
  if [ ! -f /etc/nginx/sites-enabled/hoodpub_conf.nginx ]; then
    ln -s /etc/nginx/sites-available/hoodpub_conf.nginx  /etc/nginx/sites-enabled/
  fi
  /etc/init.d/nginx restart
  BASH
  action :run
end

hostsfile_entry '127.0.0.1' do
  hostname  'redis'
  action    :create
end


ENV['HOME'] = node.hoodpub.deploy_path
