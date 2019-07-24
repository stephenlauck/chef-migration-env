#
# Cookbook:: chef-migration-env
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

chef_ingredient "chef-server" do
  config <<-EOS
api_fqdn '#{node['chef_server']['fqdn']}'
EOS
  action :install
end

ingredient_config "chef-server" do
  notifies :run, 'execute[chef-server-ctl reconfigure with license acceptance]', :immediately
end

execute 'chef-server-ctl reconfigure with license acceptance' do
  command <<-EOF
    chef-server-ctl reconfigure --chef-license=accept
    chef-server-ctl install chef-manage
    chef-server-ctl reconfigure
    chef-manage-ctl reconfigure --accept-license
    chef-server-ctl user-create migration Chef Migration lauck@chef.io 'password' --filename /tmp/migration.pem
    chef-server-ctl org-create migration 'Chef Migration' --association_user migration --filename /tmp/migration-validator.pem
    EOF
  action :nothing
end
