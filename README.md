jcouchbase
==========

Quick and dirty Couchbase jruby wrapper gem.

Use for Couchbase 2.x series.

installation
============

gem install jcouchbase

usage
=====

require 'couchbase'

c = Couchbase.new('http://xocouch01.localcloud:8091/pools', 'default', 'secretpassword' )

c.set( 'mykey', 0, { 'blah' => 'blarg', 'blip' => [ 'bloop', 'blorp', 'blop' ] } )

p c['mykey']

c.shutdown

