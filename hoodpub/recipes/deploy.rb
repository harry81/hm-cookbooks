bash "fetch hoodpub" do
  user "deploy"
  cwd node.hoodpub.src_path

  code <<-BASH
  if [ ! -d hoodpub ]; then
    git clone #{node.hoodpub.src_git_url}
    cd hoodpub
  else
    cd hoodpub
    git fetch -p
    git reset --hard origin/master
  fi
  BASH
  action :run
end

bash "pip install package" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  if [ ! -d .venv-hoodpub ]; then
    virtualenv .venv-hoodpub
  fi
  source .venv-hoodpub/bin/activate
  pip install -r src/hoodpub/web/requirements.txt
  BASH
  action :run
end

bash "migrate" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source .venv-hoodpub/bin/activate
  cd src/hoodpub/web
  python manage.py collectstatic --noinput
  python manage.py migrate
  BASH
  action :run
end

bash "run uwsgi" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source .venv-hoodpub/bin/activate
  cd src/hoodpub/web

  pids=$(ps aux | grep uwsgi | grep -i hoodpub | awk '{print $2}')
  if [ -z pids ]; then
    echo "no process"
  else
    kill -9 pids
  fi

  uwsgi --ini uwsgi-hoodpub.ini
  BASH
  action :run
end


hostsfile_entry '127.0.0.1' do
  hostname  'redis'
  action    :append
end

hostsfile_entry '127.0.0.1' do
  hostname  'postgres'
  action    :append
end

hostsfile_entry '127.0.0.1' do
  hostname  'rabbitmq'
  action    :append
end
