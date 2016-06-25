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
package "libxslt1-dev"
package "rabbitmq-server"

include_recipe "database::postgresql"

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


ENV['HOME'] = node.hoodpub.deploy_path

postgresql_connection_info = {
  :host     => '127.0.0.1',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

# Create a postgresql user but grant no privileges
postgresql_database_user 'hoodpub' do
  connection postgresql_connection_info
  password   'hoodpub81'
  action     :create
end

# create a postgresql database with additional parameters
postgresql_database 'hoodpub' do
  connection postgresql_connection_info
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner 'hoodpub'
  action :create
end
