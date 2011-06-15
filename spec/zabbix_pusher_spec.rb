# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), "/spec_helper")
require 'ap'

describe ZabbixPusher::Pusher do

  context 'Initialization' do

    FakeWeb.register_uri(:post, "http://localhost:4568/jolokia", :response => fixture_file("cms_perm_response.txt"))

    it 'should accept a template file' do
      @m = ZabbixPusher::Pusher.new(File.join(File.dirname(__FILE__), 'fixtures/tomcat_template.xml'),:jmx => {:base_uri => "http://localhost:4568"})
      @m.send.should == {
          "java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;max" => 67108864,
    "java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;committed" => 31518720,
         "java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;used" => 18890360
}
    end

  end

  context 'process items' do


    before(:each) do
    end

    it "should get the title" do
    end


  end

end