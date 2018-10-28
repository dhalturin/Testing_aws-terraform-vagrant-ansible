# encoding: utf-8
# copyright: 2018, The Authors

db_name = 'testbase'
db_user = 'testuser'
db_pass = '3JnAgNH5rNOaiQ'

sql = postgres_session(db_user, db_pass, '127.0.0.1')

describe sql.query('\l', [ db_name ]) do
  its('output') { should match sprintf("^%s|%s", db_name, db_user) }
end

describe sql.query('\dt', [ db_name ]) do
  its('output') { should match sprintf("^public|data|%s|%s", db_name, db_user) }
end
