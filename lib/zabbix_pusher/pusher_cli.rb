#
# Author:: Edmund Haselwanter (<office@iteh.at>)
# Copyright:: Copyright (c) 2011 Edmund Haselwanter
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'mixlib/cli'

module ZabbixPusher
  class PusherCLI
    include Mixlib::CLI

    option :config_file,
      :short => "-c CONFIG",
      :long  => "--config CONFIG",
      :default => 'config.rb',
      :description => "The configuration file to use"

    option :templates,
      :short => "-t FILE",
      :long  => "--template FILE",
      :default => File.join(ZabbixPusher.root,"examples"),
      :description => "The template file(s) to use, can be a file a comma separated list of files or a directory",
      #:required => true,
      :proc => Proc.new { |t| (t =~ /,/) ? t.split(',') : t }

    option :zabbix_server_name,
      :short => "-z SERVER",
      :long  => "--zabbix-server SERVER",
      :default => 'localhost',
      :description => "Hostname or IP address of Zabbix Server"

    option :zabbix_server_port,
        :short => "-p SERVER PORT",
        :long  => "--port SERVER PORT",
        :default => '10051',
        :description => "Specify port number of server trapper running on the server. Default is 10051"

    option :sender_hostname,
        :short => "-s HOST",
        :long  => "--host HOSTNAME",
        :description => "Specify host name. Host IP address and DNS name will not work."

    option :log_level,
      :short => "-l LEVEL",
      :long  => "--log_level LEVEL",
      :description => "Set the log level (debug, info, warn, error, fatal)",
      :proc => Proc.new { |l| l.to_sym }

    option :show_send_values,
      :short => "-v",
      :long  => "--show_send_values",
      :description => "shows what values got send to zabbix",
      :boolean => true

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0

  end
end
