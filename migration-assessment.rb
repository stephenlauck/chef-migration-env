#!/opt/chefdk/embedded/bin/ruby

require 'chef'
require 'fauxhai'
require 'faker'

Chef::Config.from_file("/Users/stephen/.chef/knife.rb")
rest = Chef::ServerAPI.new(Chef::Config[:chef_server_url])

nodes = Chef::Search::Query.new(Chef::Config[:chef_server_url]).search(:node, '*:*', :filter_result => {'name' => ['name'] } )

puts nodes.first

# create node object
(10..20).each do |n|
  n = Chef::Node.new
  n.name("#{Faker::Alphanumeric.alphanumeric 10}")
  n.chef_environment("test-environment")
  n.run_list << 'role[foo]'

  # inject fauxhai data
  n.consume_external_attrs(Fauxhai.mock(platform: 'ubuntu', version: '14.04').data,  {})

  # save the node
  n.save
end
