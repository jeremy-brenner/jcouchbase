# Copyright (C) 2012 Jeremy Brenner
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in coSmpliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Couchbase

  include_class java.io.IOException
  include_class java.net.SocketAddress
  include_class java.net.URI
  include_class java.net.URISyntaxException
  include_class java.util.ArrayList
  include_class java.util.LinkedList
  include_class java.util.List
  include_class java.util.concurrent.Future
  include_class java.util.concurrent.TimeUnit

  include_class javax.naming.ConfigurationException

  include_class Java::net.spy.memcached.CASMutation
  include_class Java::net.spy.memcached.CASMutator
  include_class Java::net.spy.memcached.CASResponse
  include_class Java::net.spy.memcached.CASValue
  include_class Java::net.spy.memcached.CachedData
  include_class Java::net.spy.memcached.ConnectionObserver
  include_class Java::net.spy.memcached.transcoders.SerializingTranscoder
  include_class Java::net.spy.memcached.transcoders.Transcoder

  include_class Java::org.apache.http.HttpEntity
  include_class Java::org.apache.http.HttpEntityEnclosingRequest
  include_class Java::org.apache.http.HttpHost
  include_class Java::org.apache.http.HttpRequest
  include_class Java::org.apache.http.HttpResponse
  include_class Java::org.apache.http.HttpStatus
  include_class Java::org.apache.http.ProtocolVersion
  include_class Java::org.apache.http.client.ClientProtocolException
  include_class Java::org.apache.http.client.HttpClient
  include_class Java::org.apache.http.entity.ByteArrayEntity
  include_class Java::org.apache.http.impl.cookie.DateUtils
  include_class Java::org.apache.http.message.BasicHttpEntityEnclosingRequest
  include_class Java::org.apache.http.message.BasicHttpRequest
  include_class Java::org.apache.http.message.BasicHttpResponse
  include_class Java::org.apache.http.protocol.HttpContext

  include_class com.couchbase.client.CouchbaseClient
  include_class com.couchbase.client.CouchbaseConnectionFactory
  Observer = java.util.Observer

  def initialize(pool_uris, bucket, password='')
    @urilist = ArrayList.new
    pool_uris = [ pool_uris ] if pool_uris.is_a? String
    pool_uris.each { |uri| @urilist << URI.new(uri) }
    @bucket = bucket
    @password = password
    self.connect
  end

  def connect
    @connection_factory = CouchbaseConnectionFactory.new( @urilist, @bucket.to_java_string, @password.to_java_string )
    @client = CouchbaseClient.new(@connection_factory)
    self
  end

  def javify(o)
    if( o.is_a? Hash )
      o.each { |k,v| o[k] = self.javify(v) }
      return java.util.HashMap.new( o )
    end
    if( o.is_a? Array )
       o.each_index { |i| o[i] = self.javify( o[i] ) }
       return java.util.ArrayList.new( o )
    end
    return o
  end

  def rubify(o)
    if( o.is_a? Java::JavaUtil::HashMap )
      h = {}
      o.each { |k,v| h[k] = self.rubify(v) }
      return h
    end
    if( o.is_a? Java::JavaUtil::ArrayList )
       a = []
       o.each { |v| a << self.rubify(v) }
       return a
    end
    return o
  end

  %w( shutdown add append delete asyncCAS asyncDecr asyncGetAndTouch asyncGet asyncGetBulk asyncGet asyncGets asyncIncr cas decr delete getAndTouch getBulk get gets getStats incr prepend replace set touch ).each do |meth|
    define_method(meth) do |*args|
      self.rubify( @client.send( meth.to_sym, *args.map { |a| self.javify(a) } ) )
    end
  end

  def []= ( key, value )
    self.set( key, 0, value )
  end

  def [] ( key )
    self.get( key )
  end
end
