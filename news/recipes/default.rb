#
# Cookbook Name:: news
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

user node.news.deploy do
  comment 'news user'
  home node.news.deploy_path
  uid '1234'
  shell '/bin/zsh'
  supports :manage_home => true
  password '$1$077OG8Lh$iarEmNtv.2wybHMPNDgr81'
  action :create
end

directory node.news.src_path do
  owner node.news.deploy
  group node.news.deploy
  mode "0755"
  recursive true
  action :create
end

template '/home/deploy/.zshrc' do
  source 'zshrc.erb'
  owner 'deploy'
  mode '0644'
end

template '/etc/nginx/sites-available/news_conf.nginx' do
  source 'news_conf_nginx.erb'
  owner 'deploy'
  mode '0644'
end

bash "link nginx conf" do
  user "root"
  code <<-BASH
  if [ ! -f /etc/nginx/sites-enabled/news_conf.nginx ]; then
    ln -s /etc/nginx/sites-available/news_conf.nginx  /etc/nginx/sites-enabled/
  fi
  /etc/init.d/nginx restart
  BASH
  action :run
end

bash "fetch news" do
  user "deploy"
  cwd node.news.src_path

  code <<-BASH
  if [ ! -d news ]; then
    git clone #{node.news.src_git_url}
    cd news
  else
    cd news
    git fetch -p
    git reset --hard origin/master
  fi
  BASH
  action :run
end

ENV['HOME'] = node.news.deploy_path
ENV['JAVA_HOME'] = node.news.java_home

bash "pip install package" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  if [ ! -d venv ]; then
    virtualenv venv
  fi
  source venv/bin/activate
  pip install -r src/news/backend/requirements.txt
  BASH
  action :run
end
