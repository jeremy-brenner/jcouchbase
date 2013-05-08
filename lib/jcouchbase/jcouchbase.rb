# Copyright (C) 2012 Jeremy Brenner
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
include Java

class Couchbase

  import java.io.IOException
  import java.net.SocketAddress
  import java.net.URI
  import java.net.URISyntaxException
  import java.util.ArrayList
  import java.util.LinkedList
  import java.util.List
  import java.util.concurrent.Future
  import java.util.concurrent.TimeUnit

  import javax.naming.ConfigurationException

  import Java::net.spy.memcached.CASMutation
  import Java::net.spy.memcached.CASMutator
  import Java::net.spy.memcached.CASResponse
  import Java::net.spy.memcached.CASValue
  import Java::net.spy.memcached.CachedData
  import Java::net.spy.memcached.ConnectionObserver
  import Java::net.spy.memcached.transcoders.SerializingTranscoder
  import Java::net.spy.memcached.transcoders.Transcoder

  import Java::org.apache.http.HttpEntity
  import Java::org.apache.http.HttpEntityEnclosingRequest
  import Java::org.apache.http.HttpHost
  import Java::org.apache.http.HttpRequest
  import Java::org.apache.http.HttpResponse
  import Java::org.apache.http.HttpStatus
  import Java::org.apache.http.ProtocolVersion
  import Java::org.apache.http.client.ClientProtocolException
  import Java::org.apache.http.client.HttpClient
  import Java::org.apache.http.entity.ByteArrayEntity
  import Java::org.apache.http.impl.cookie.DateUtils
  import Java::org.apache.http.message.BasicHttpEntityEnclosingRequest
  import Java::org.apache.http.message.BasicHttpRequest
  import Java::org.apache.http.message.BasicHttpResponse
  import Java::org.apache.http.protocol.HttpContext

  import com.couchbase.client.CouchbaseClient
  import com.couchbase.client.CouchbaseConnectionFactory

  import com.couchbase.client.protocol.views.Query

  Observer = java.util.Observer

  def initialize(pool_uris, bucket, password='')
    @urilist = ArrayList.new
    pool_uris = [pool_uris] if pool_uris.is_a? String
    pool_uris.each { |uri| @urilist << URI.new(uri) }
    @bucket = bucket
    @password = password
    self.connect
  end

  def connect
    @connection_factory = CouchbaseConnectionFactory.new(@urilist, @bucket.to_java_string, @password.to_java_string)
    @client = CouchbaseClient.new(@connection_factory)
    self
  end

  #based on https://gist.github.com/erdeszt/4154011 by
  def get_view(design, view, keys = nil, include_docs = true)
    query = Query.new
    query.setIncludeDocs(include_docs)
    view = @client.getView(design, view)
    if keys.is_a? Array
      query.setKeys("[#{keys.map{|e| "[#{e.to_json}]"}.join(',')}]")
    else
      query.setKey("[#{keys.to_json}]") 
    end
    @client.asyncQuery(view, query).get.iterator.map do |row|
      {
          :id => row.getId,
          :document => to_hash(row.getDocument),
          :view_key => row.getKey,
          :view_value => row.getValue,
      }
    end
  end

  def javify(o)
    if o.is_a? Hash
      o.each { |k, v| o[k] = self.javify(v) }
      return java.util.HashMap.new(o)
    end
    if o.is_a? Array
      o.each_index { |i| o[i] = self.javify(o[i]) }
      return java.util.ArrayList.new(o)
    end
    o
  end

  def rubify(o)
    if o.is_a? Java::JavaUtil::HashMap
      h = {}
      o.each { |k, v| h[k] = self.rubify(v) }
      return h
    end
    if o.is_a? Java::JavaUtil::ArrayList
      a = []
      o.each { |v| a << self.rubify(v) }
      return a
    end
    o
  end

  %w( shutdown add append delete asyncCAS asyncDecr asyncGetAndTouch asyncGet asyncGetBulk asyncGet asyncGets asyncIncr cas decr delete getAndTouch getBulk get gets getStats getView incr prepend replace set touch ).each do |meth|
    define_method(meth) do |*args|
      self.rubify(@client.send(meth.to_sym, *args.map { |a| self.javify(a) }))
    end
  end

  def []= (key, value)
    self.set(key, 0, value)
  end

  def [](key)
    to_hash(self.get(key))
  end

  private
  def to_hash(value)
    Hash[JSON.parse(value).map { |key, value| [key.to_sym, value] }]
  end

end
