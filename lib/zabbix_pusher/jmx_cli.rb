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

    option :jmx__base_uri,
      :long  => "--jmx_base_uri uri",
      :description => "The jmx base uri"

  end

  class JmxCLI
    include Mixlib::CLI

    option :base_uri,
      :short => "-b uri",
      :default => "localhost:8080",
      :long  => "--base_uri uri",
      :description => "The jmx base uri"

    option :command,
      :short => "-o command",
      :default => "read",
      :long  => "--command action",
      :description => "The command to perform",
      :proc => Proc.new { |o| o.to_sym }

    option :mbean,
      :short => "-m mbean",
      :long  => "--mbean mbean",
      :description => "The name of the mbean e.g. java.lang:type=Memory (needed for read command)"

    option :attribute,
      :short => "-a attribute",
      :long  => "--attribute attribute",
      :description => "The name of the action e.g. HeapMemoryUsage (needed for read command)"

    option :path,
      :short => "-p path",
      :long  => "--path path",
      :description => "The name of the path e.g. used (needed for read and list command)"

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
