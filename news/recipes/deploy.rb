bash "migrate" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
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
  source venv/bin/activate
  cd src/news/backend
  uwsgi --ini uwsgi.ini
  BASH
  action :run
end
