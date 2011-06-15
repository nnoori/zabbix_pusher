require "zabbix_pusher/version"
require "active_support/core_ext/string/inflections.rb"
require 'nokogiri'
require 'yajl/json_gem'

module ZabbixPusher
  class Pusher
    def initialize(templates, options = {} )
      options[:zabbix_server_name] = 'localhost' unless options[:zabbix_server_name]
      options[:zabbix_server_port] = '10051' unless options[:zabbix_server_port]

      @options = options

      @templates = []
      @templates = Dir.glob(File.join(templates),'*.xml') if File.directory?(templates)
      @templates = templates.map{ |template| template if File.exist?(template) }.compact if templates.is_a?(Array)
      @templates =  [templates] if File.exist?(templates)

      @items = Hash.new

      @templates.each do |template|
        template_items = Nokogiri::XML(File.open(template))
        items = template_items.xpath('//item').map {|item| item.attributes['key'].text}.compact
        items.each do |item|
            parts = item.match(/([^\[]+)\[([^\]]+)/)
            key = parts[1]
            attributes = parts[2]
            (@items[key.to_sym]) ? @items[key.to_sym] << attributes : @items[key.to_sym] = [attributes]
        end
      end
    end

    def send(items = :all)

      return if @items.nil?

      pushers = ( items == :all) ? (@items.keys.map{ |key| "ZabbixPusher::#{key.to_s.camelize}".constantize}) : ["ZabbixPusher::#{items.camelize}".constantize]

      processed_items = Hash.new

      pushers.map do |pusher|
        pusher_key = pusher.to_s.demodulize.underscore.to_sym
        processed_items.update pusher.new(@items[pusher_key],@options[pusher_key]).send(:processed_items)
      end
      processed_items
    end
  end

  require 'httparty'

  class Jmx

    include HTTParty
    base_uri 'http://localhost:8080'
    format :json

    def initialize(items,options)
      self.class.base_uri options[:base_uri] if options[:base_uri]
      @payload = Array.new
      @items = items
      @items.each do |item|  mbean,attribute,path = item.split(';')
        tokens = { "mbean" => mbean, "attribute" => attribute, "type" => "READ"}
        tokens["path"] = path if path
        @payload  << tokens
      end
    end

    def processed_items
      data = self.class.post('/jolokia', :body => @payload.to_json)
      result = Hash.new
      data.each{|datum| result[result_key(datum)] = datum['value'] if datum['request']}
      result
    end

    def result_key(datum)
      "#{datum['request']['mbean']};#{datum['request']['attribute']};#{datum['request']['path']}"
    end
  end

end
