# encoding: utf-8
# copyright: 2018, The Authors

describe command("wget -qO- http://127.0.0.1/?n=15") do
  its("stdout") { should match "^0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610$" }
end

describe command("wget -qO- http://127.0.0.1/blacklisted -S 2>&1") do
  its("stdout") { should match "^[\s]+HTTP/1.1 444" }
end
