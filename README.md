# Zabbix Pusher

* Source: [http://github.com/iteh/zabbix_pusher](http://github.com/iteh/zabbix_pusher)

Zabbix Pusher is a gem with a set of binaries to push data to a zabbix server

The current package provides a implementation for querying jmx data with
[jolokia](http://www.jolokia.org/) from tomcat and a predefined tomcat_template.xml to import in zabbix.
You must deploy the jolkia.war to your tomcat instance.

## Quick Start

Install the gem with.

    gem install zabbix_pusher

import the examples/tomcat_template.xml into your zabbix server

    zabbix_pusher  -z 192.168.1.40 -s vagrantup.com  -v

sample output:

    {
                          "jmx[java.lang:type=OperatingSystem;OpenFileDescriptorCount;]" => 46,
                  "jmx[Catalina:name=http-8080,type=GlobalRequestProcessor;errorCount;]" => 1,
                               "jmx[java.lang:type=ClassLoading;TotalLoadedClassCount;]" => 1918,
                           "jmx[java.lang:type=OperatingSystem;MaxFileDescriptorCount;]" => 1024,
                                                   "jmx[java.lang:type=Runtime;Uptime;]" => 4807550,
                                    "jmx[java.lang:type=ClassLoading;LoadedClassCount;]" => 1916,
                              "jmx[Catalina:name=http-8080,type=ThreadPool;maxThreads;]" => 200,
                                 "jmx[java.lang:type=Compilation;TotalCompilationTime;]" => 852,
                                                "jmx[java.lang:type=Runtime;VmVersion;]" => "19.1-b02",
                            "jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;max]" => 67108864,
                                                 "jmx[Catalina:type=Server;serverInfo;]" => "Apache Tomcat/6.0.24",
               "jmx[Catalina:name=http-8080,type=GlobalRequestProcessor;bytesReceived;]" => 616016,
                                                 "jmx[java.lang:type=Compilation;Name;]" => "HotSpot Client Compiler",
                        "jmx[java.lang:name=Copy,type=GarbageCollector;CollectionTime;]" => 114,
                           "jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;used]" => 10244896,
                                      "jmx[java.lang:type=Threading;DaemonThreadCount;]" => 13,
                       "jmx[java.lang:name=CMS Old Gen,type=MemoryPool;Usage;committed]" => 50331648,
                             "jmx[java.lang:name=Code Cache,type=MemoryPool;Usage;used]" => 2310528,
                "jmx[Catalina:name=http-8080,type=GlobalRequestProcessor;requestCount;]" => 173,
              "jmx[Catalina:name=http-8080,type=GlobalRequestProcessor;processingTime;]" => 1992,
                      "jmx[Catalina:name=http-8080,type=ThreadPool;currentThreadsBusy;]" => 1,
                                            "jmx[java.lang:type=Threading;ThreadCount;]" => 14,
        "jmx[java.lang:name=ConcurrentMarkSweep,type=GarbageCollector;CollectionCount;]" => 4,
                        "jmx[java.lang:name=Code Cache,type=MemoryPool;Usage;committed]" => 2326528,
                              "jmx[java.lang:name=Code Cache,type=MemoryPool;Usage;max]" => 33554432,
                   "jmx[Catalina:name=http-8080,type=GlobalRequestProcessor;bytesSent;]" => 9622082,
                      "jmx[Catalina:name=http-8080,type=ThreadPool;currentThreadCount;]" => 1,
                                        "jmx[java.lang:type=Threading;PeakThreadCount;]" => 14,
                             "jmx[java.lang:name=CMS Old Gen,type=MemoryPool;Usage;max]" => 83886080,
                            "jmx[java.lang:name=CMS Old Gen,type=MemoryPool;Usage;used]" => 3707304,
         "jmx[java.lang:name=ConcurrentMarkSweep,type=GarbageCollector;CollectionTime;]" => 0,
                      "jmx[java.lang:name=CMS Perm Gen,type=MemoryPool;Usage;committed]" => 17063936,
                                  "jmx[java.lang:type=ClassLoading;UnloadedClassCount;]" => 2,
                            "jmx[java.lang:type=Memory;ObjectPendingFinalizationCount;]" => 0,
                                "jmx[java.lang:type=Threading;TotalStartedThreadCount;]" => 14,
                       "jmx[java.lang:name=Copy,type=GarbageCollector;CollectionCount;]" => 49,
                             "jmx[Catalina:port=8080,type=ProtocolHandler;compression;]" => "off"
    }

will push the data to a zabbix server running on port 10051. The -v option will print out what gets send to the server.

## Options

    zabbix_pusher -h
    Usage: zabbix_pusher (options)
        -c, --config CONFIG              The configuration file to use
            --jmx_base_uri uri           The jmx base uri
        -l, --log_level LEVEL            Set the log level (debug, info, warn, error, fatal)
        -s, --host HOSTNAME              Specify host name. Host IP address and DNS name will not work.
        -v, --show_send_values           shows what values got send to zabbix
        -t, --template FILE              The template file(s) to use, can be a file a comma separated list of files or a directory
        -z, --zabbix-server SERVER       Hostname or IP address of Zabbix Server
        -p, --port SERVER PORT           Specify port number of server trapper running on the server. Default is 10051
        -h, --help                       Show this message

## Additional Command zabbix_pusher_jmx

Can be used to explore all the options of your jmx data.

    $ zabbix_pusher_jmx -h
    Usage: /usr/bin/zabbix_pusher_jmx (options)
        -a, --attribute attribute        The name of the action e.g. HeapMemoryUsage (needed for read command)
        -b, --base_uri uri               The jmx base uri
        -o, --command action             The command to perform
        -m, --mbean mbean                The name of the mbean e.g. java.lang:type=Memory (needed for read command)
        -p, --path path                  The name of the path e.g. used (needed for read and list command)
        -h, --help                       Show this message

Examples:

    zabbix_pusher_jmx --command search -m "Catalina:*"
    zabbix_pusher_jmx --command read -m "Catalina:host=localhost,path=/,type=Manager"
    zabbix_pusher_jmx --command read -m "Catalina:name=http-8080,type=GlobalRequestProcessor" -a bytesReceived
    zabbix_pusher_jmx --command list -m Catalina:host=localhost,path=/,resourcetype=Context,type=NamingResources

See [http://www.jolokia.org/reference/html/protocol.html](http://www.jolokia.org/reference/html/protocol.html) for details