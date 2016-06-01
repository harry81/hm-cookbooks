default["hoodpub"]["deploy"] = "deploy"
default["hoodpub"]["deploy_path"] = "/home/#{node.hoodpub.deploy}"
default["hoodpub"]["src_path"] = "#{node.hoodpub.deploy_path}/src"
default["hoodpub"]["src_git_url"]="https://github.com/harry81/hoodpub.git"

node.default['postgresql']['version']="9.4"
node.default['postgresql']['password']['postgres']="hoodpub81"
node.default['postgresql']['config']['port']=5432
