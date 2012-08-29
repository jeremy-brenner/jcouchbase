jcouchbase
==========

Quick and dirty Couchbase jruby wrapper gem.

Use for Couchbase 2.x series.

installation
============

gem install jcouchbase

usage
=====

require 'jcouchbase'

c = Couchbase.new('http://xocouch01.localcloud:8091/pools', 'default', 'secretpassword' )

c.set( 'mykey', 0, { 'blah' => 'blarg', 'blip' => [ 'bloop', 'blorp', 'blop' ] } )

p c['mykey']

c.shutdown

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

