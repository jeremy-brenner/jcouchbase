Gem::Specification.new do |s|
  s.name              = 'jcouchbase'
  s.version           = '0.1.5'
  s.date              = '2013-04-11'
  s.platform          = Gem::Platform::JAVA
  s.authors           = ["Jeremy J Brenner"]
  s.email             = ["jeremyjbrenner@gmail.com"]
  s.summary           = "Thin ruby wrapper around Couchbase Java Driver; for JRuby only"
  s.description       = %q{Thin jruby wrapper around Couchbase Java Driver}
  s.homepage          = 'http://github.com/jeremy-brenner/jcouchbase'

  # = MANIFEST =
  s.files = %w[
    Gemfile
    README.md
    Rakefile
    jcouchbase.gemspec
    lib/jcouchbase.rb
    lib/jcouchbase/jars/asm-4.1.jar
    lib/jcouchbase/jars/cglib-2.2.2.jar
    lib/jcouchbase/jars/commons-codec-1.7.jar
    lib/jcouchbase/jars/commons-logging-1.1.2.jar
    lib/jcouchbase/jars/couchbase-client-1.1.4-sources.jar
    lib/jcouchbase/jars/couchbase-client-1.1.4.jar
    lib/jcouchbase/jars/fluent-hc-4.2.3.jar
    lib/jcouchbase/jars/httpclient-4.2.3.jar
    lib/jcouchbase/jars/httpclient-cache-4.2.3.jar
    lib/jcouchbase/jars/httpcore-4.2.4.jar
    lib/jcouchbase/jars/httpcore-nio-4.2.4.jar
    lib/jcouchbase/jars/httpmime-4.2.3.jar
    lib/jcouchbase/jars/jettison-1.3.3.jar
    lib/jcouchbase/jars/log4j-1.2.17.jar
    lib/jcouchbase/jars/netty-3.6.3.Final.jar
    lib/jcouchbase/jars/spymemcached-2.8.12-javadocs.jar
    lib/jcouchbase/jars/spymemcached-2.8.12-sources.jar
    lib/jcouchbase/jars/spymemcached-2.8.12.jar
    lib/jcouchbase/jcouchbase.rb
    lib/jcouchbase/version.rb
  ]
  # = MANIFEST =

  s.add_dependency 'require_all',                 '~> 1.2'
  
end
