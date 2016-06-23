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

bash "run news uwsgi" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source .venv-news/bin/activate
  cd src/news/backend

  pids=$(ps aux | grep uwsgi | grep -i news | awk '{print $2}')
  if [ -z pids ]; then
    echo "no process"
  else
    kill -9 pids
  fi
  uwsgi --ini uwsgi-news.ini

  BASH
  action :run
end
