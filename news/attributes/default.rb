default["news"]["deploy"] = "deploy"
default["news"]["deploy_path"] = "/home/#{node.news.deploy}"
default["news"]["src_path"] = "#{node.news.deploy_path}/src"
default["news"]["src_git_url"]="https://github.com/harry81/news.git"
default["news"]["java_home"]="/usr/lib/jvm/java-7-openjdk-amd64"

node.default['postgresql']['version']="9.4"
node.default['postgresql']['password']['postgres']="hoodpub81"
node.default['postgresql']['config']['port']=5432
