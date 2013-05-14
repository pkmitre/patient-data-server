# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
db_name = Mongoid.default_session.options[:database]
host_name = Mongoid.default_session.cluster.nodes.first.address
`mongoimport -d #{db_name} -h #{host_name} --drop -c records test/fixtures/records.json`
`mongoimport -d #{db_name} -h #{host_name} --drop -c clients test/fixtures/clients.json`
`mongoimport -d #{db_name} -h #{host_name} --drop -c users test/fixtures/users.json`
`mongoimport -d #{db_name} -h #{host_name} --drop -c ref_consult_requests test/fixtures/ref_consult_requests.json`
`mongoimport -d #{db_name} -h #{host_name} --drop -c ref_numbers test/fixtures/ref_numbers.json`
