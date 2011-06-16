# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zabbix_pusher/version"

Gem::Specification.new do |s|
  s.name        = "zabbix_pusher"
  s.version     = ZabbixPusher::VERSION
  s.authors     = ["Edmund Haselwanter"]
  s.email       = ["edmund@haselwanter.com"]
  s.homepage    = "http://iteh.at"
  s.license     = 'Apache'

  s.summary     = %q{Push data to Zabbix}
  s.description = %q{zabbix_pusher is a gem to parse zabbix templates and push the data to the corresponding zabbix server}

  s.rubyforge_project = "zabbix_pusher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri', '~> 1.4.4'
  s.add_dependency 'zabbix', '~> 0.3.0'
  s.add_dependency 'httparty', '~> 0.7.8'
  s.add_dependency 'activesupport', '~> 3.0.8'
  s.add_dependency "i18n", "~> 0.6.0"
  s.add_dependency 'yajl-ruby', '~> 0.8.2'
  s.add_dependency "awesome_print", "~> 0.4.0"
  s.add_dependency "mixlib-cli", "~> 1.2.0"

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'

end
