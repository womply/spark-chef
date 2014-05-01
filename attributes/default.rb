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
  :master_port => 7077,
  :master_webui_port => 8080,
  :worker_cores => nil,
  :worker_memory => nil,
  :worker_port => nil,
  :worker_webui_port => 8081,
  :worker_instances => nil,
  :worker_dir => nil,
  :daemon_memory => nil,
  :properties => {},
  :hadoop_version => '1.0.4',
  :yarn => false,
  :classpath => nil,
  :limits => {
    :nofile => 100000,
    :nproc => 32768
  }
}

