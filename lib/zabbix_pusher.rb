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

require "zabbix_pusher/version"
require "active_support/core_ext/string/inflections.rb"
require 'nokogiri'
require 'yajl/json_gem'
require 'zabbix'
require "socket"
require "zabbix_pusher/jmx"

module ZabbixPusher

  def self.root
    @root ="#{File.expand_path('../..',__FILE__)}"
  end

  class Pusher
    def initialize(templates, options = {} )
      options[:zabbix_server_name] = 'localhost' unless options[:zabbix_server_name]
      options[:zabbix_server_port] = '10051' unless options[:zabbix_server_port]
      options[:sender_hostname] = Socket.gethostname unless options[:sender_hostname]

      @options = options
      @templates = template_files(templates)
      @items = template_items(@templates)
    end

    def template_files(templates)
      template_files = []
      template_files = Dir.glob(File.join(templates,'*.xml')) if !templates.is_a?(Array) && File.directory?(templates)
      template_files = templates.map{ |template| template if File.exist?(template) }.compact if templates.is_a?(Array)
      template_files =  [templates] if !templates.is_a?(Array) && File.exist?(templates) && !File.directory?(templates)
      template_files
    end

    def template_items(templates)
      parsed_items = Hash.new

      templates.each do |template|
        template_items = Nokogiri::XML(File.open(template))
        items = template_items.xpath('//item').map {|item| item.attributes['key'].text}.compact
        items.each do |item|
            parts = item.match(/([^\[]+)\[([^\]]+)/)
            unless parts.nil?
              key = parts[1].underscore.to_sym
              attributes = parts[2]
              (parsed_items[key]) ? parsed_items[key] << attributes : parsed_items[key] = [attributes]
            else
              puts "not evaluating: "+item
            end
        end
      end
      parsed_items
    end

    def send(items = :all)

      return if @items.nil?


      pushers = ( items == :all) ? ( @items.keys.map{ |key| "ZabbixPusher::#{key.to_s.camelize}".constantize }) : ["ZabbixPusher::#{items.camelize}".constantize]

      processed_items = Hash.new

      pushers.map do |pusher|
        pusher_key = pusher.to_s.demodulize.underscore.to_sym
        processed_items.update pusher.new(@items[pusher_key],@options[pusher_key]).send(:processed_items)
      end

      zbx  = Zabbix::Sender::Buffer.new :host => @options[:zabbix_server_name], :port => @options[:zabbix_server_port]

      processed_items.each do |key,value|
        zbx.append key, value, :host => @options[:sender_hostname]
      end
      zbx.flush

      processed_items
    end
  end

end
