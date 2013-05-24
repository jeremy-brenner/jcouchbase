jcouchbase
==========

Quick and dirty Couchbase jruby wrapper gem.

Use for Couchbase 2.x series.

installation
============

gem install jcouchbase

usage
=====
```ruby
require 'jcouchbase'

c = Couchbase.new('http://xocouch01.localcloud:8091/pools', 'default', 'secretpassword' )

c.set( 'mykey', 0, { 'blah' => 'blarg', 'blip' => [ 'bloop', 'blorp', 'blop' ] } )

p c['mykey']

c.get_view('sample_design_doc', 'sample_view', 'sample_key')
c.get_view('sample_design_doc', 'sample_view', ['sample_key1','sample_key2'])

#query view using a single or multiple keys
key = {:id=> "1", :name=> "reza"}
c.get_view('sample_design_doc', 'sample_view', key)

keys = [{:id=> "1", :name=> "ali"}, {:id=> "2", :name=>"sali"}] 
c.get_view('sample_design_doc', 'sample_view', keys) 


# remember that the order of keys inside argument  must be the same as defined in the view
# for example the next expression return nothing even if the corresponding record is available  
wrong_key= {:name=>"reza", :id=> "1"}
c.get_view('sample_design_doc', 'sample_view', wrong_key) 

c.shutdown
```

use log4j
=====
```ruby
def setup_log4j
  java::lang.System.setProperty("net.spy.log.LoggerImpl", "net.spy.memcached.compat.log.Log4JLogger")

  fa = Java::OrgApacheLog4j::FileAppender.new();
  fa.setName("FileLogger");

  fa.setFile("./log/#{Rails.env}.log");
  fa.setLayout(Java::OrgApacheLog4j::PatternLayout.new("%d %-5p [%c{1}] %m%n"));
  fa.setThreshold(Java::OrgApacheLog4j::Level::INFO);
  fa.setAppend(true);
  fa.activateOptions();
  Java::OrgApacheLog4j::Logger.getRootLogger().addAppender(fa)
end
setup_log4j
```

links
=====

Couchbase: http://www.couchbase.com

Java Library: http://www.couchbase.com/develop/java/next

API Reference
=============

jcouchbase exposes access to the methods from the java api:
shutdown add append delete asyncCAS asyncDecr asyncGetAndTouch asyncGet asyncGetBulk asyncGet asyncGets asyncIncr cas decr delete getAndTouch getBulk get gets getStats incr prepend replace set touch

Reference here:
http://www.couchbase.com/docs/couchbase-sdk-java-1.1/api-reference-summary.html

In addition I have added [] and []= methods for convenience of getting and setting keys.

c['key'] = { 'blah' => 'blah', 'foo' => 'bar' }
p c['key']

