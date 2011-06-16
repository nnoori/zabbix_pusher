# -*- encoding: utf-8 -*-

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

require File.join(File.dirname(__FILE__), "/spec_helper")
require 'ap'

describe ZabbixPusher::Pusher do

  context 'Initialization' do

    FakeWeb.register_uri(:post, "http://localhost:4568/jolokia", :response => fixture_file("cms_perm_response.txt"))

    it 'should accept a template file' do
      @m = ZabbixPusher::Pusher.new(File.join(File.dirname(__FILE__), 'fixtures/tomcat_template.xml'),:jmx => {:base_uri => "http://localhost:4568"})
      @m.send.should == {"jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;max]"=>67108864, "jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;used]"=>18890360, "jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;committed]"=>31518720}

    end

  end

  context 'process items' do


    before(:each) do
    end

    it "should get the title" do
    end


  end

end