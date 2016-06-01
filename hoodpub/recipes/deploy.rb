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
  if [ ! -d venv ]; then
    virtualenv venv
  fi
  source venv/bin/activate
  pip install -r src/hoodpub/web/requirements.txt
  BASH
  action :run
end

bash "migrate" do
  user "deploy"
  cwd node.hoodpub.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
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
  source venv/bin/activate
  cd src/hoodpub/web
  kill -9 $(pidof uwsgi)

  uwsgi --ini uwsgi.ini
  BASH
  action :run
end
