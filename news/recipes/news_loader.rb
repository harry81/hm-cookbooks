bash "load news" do
  user "deploy"
  cwd node.news.deploy_path
  code <<-BASH
  export HOME=/home/deploy
  source venv/bin/activate
  cd src/news/backend
  python manage.py loadnews all
  BASH
  action :run
end
