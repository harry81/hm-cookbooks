bash "pip install package" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  if [ ! -d .venv-news ]; then
    virtualenv .venv-news
  fi
  source .venv-news/bin/activate
  pip install -r src/news/backend/requirements.txt
  BASH
  action :run
end

bash "migrate" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source .venv-news/bin/activate
  cd src/news/backend
  python manage.py migrate
  BASH
  action :run
end

bash "run uwsgi" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source .venv-news/bin/activate
  cd src/news/backend
  uwsgi --ini uwsgi.ini
  BASH
  action :run
end
