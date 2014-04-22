default[:spark] = {
  :version => '0.9.1',
  :url => 'http://d3kbcqa49mib13.cloudfront.net/spark-0.9.1.tgz',
  :checksum => 'F911EB740784A63AF5B84D0FFB73217B7640FA47F7CBAF7F1ABEFEAE05A99436B939CD5DAAC0EF84EE8F37DAC2877061A463D04352245EDB7CBD543C9E519531',
  :home => '/usr/local/spark',
  :username => 'spark',
  :spark_mem => nil,
  :local_ip => nil,
  :mesos_native_library => nil,
  :java_opts => nil,
  :slaves => [],
  :master_ip => nil,
  :master_port => nil,
  :master_webui_port => nil,
  :worker_cores => nil,
  :worker_memory => nil,
  :worker_port => nil,
  :worker_webui_port => nil,
  :worker_instances => nil,
  :worker_dir => nil,
  :properties => {},
  :hadoop_version => '2.2.0',
  :yarn => true,
  :calliope => true,
  :calliope_url => 'https://oss.sonatype.org/service/local/repositories/releases/content/com/tuplejump/calliope_2.10/0.9.0-U1-C2-EA/calliope_2.10-0.9.0-U1-C2-EA.jar',
  :cassandra_classpath => '/usr/local/spark/lib_managed/jars/calliope.jar:/usr/share/cassandra/lib/apache-cassandra-2.0.6.jar:/usr/share/cassandra/lib/apache-cassandra-thrift-2.0.6.jar:/usr/share/cassandra/lib/libthrift-0.9.1.jar'
}

