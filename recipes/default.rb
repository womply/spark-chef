#
# Cookbook Name:: spark
# Recipe:: default
#

include_recipe 'java'

package 'git'

user node.spark.username do
  username node.spark.username
  comment 'Spark'
  home node.spark.home
  supports :manage_home => false
  action :create
end

# Total hack but the home directory gets created later by ark
directory node.spark.home do
  recursive true
  action :delete
  only_if { File.directory?(node.spark.home) }
end

ark 'spark' do
  url node.spark.url
  version node.spark.version
  append_env_path true
  owner node.spark.username
  group node.spark.username
  action :install
end

if node.spark.attribute?(:local_dirs)
  node.spark.local_dirs.split(',').each do |dir|
    directory dir do
      owner node.spark.username
      group node.spark.username
      recursive true
    end
  end
end

if node.spark.assemble
  assembly_env_vars = []
  assembly_env_vars << "SPARK_HADOOP_VERSION=#{node.spark.hadoop_version}" if node.spark.hadoop_version
  assembly_env_vars << "SPARK_YARN=true" if node.spark.yarn
  bash 'build spark assembly' do
    cwd node.spark.home
    code "#{assembly_env_vars.join(' ')} sbt/sbt assembly"
    user node.spark.username
  end
end

template "#{node.spark.home}/conf/spark-env.sh" do
  source "conf-spark-env.sh.erb"
  mode 0755
  owner node.spark.username
  group node.spark.username
  variables({
    :env_vars => {
      'HADOOP_CONF_DIR' => node.spark.hadoop_conf_dir,
      'SPARK_LOCAL_IP' => node.spark.local_ip,
      'SPARK_PUBLIC_DNS' => node.spark.public_dns,
      'SPARK_CLASSPATH' => node.spark.classpath,
      'SPARK_LOCAL_DIRS' => node.spark.local_dirs,
      'MESOS_NATIVE_LIBRARY' => node.spark.mesos_native_library,
      'SPARK_EXECUTOR_INSTANCES' => node.spark.executor_instances,
      'SPARK_EXECUTOR_CORES' => node.spark.executor_cores,
      'SPARK_EXECUTOR_MEMORY' => node.spark.executor_memory,
      'SPARK_DRIVER_MEMORY' => node.spark.driver_memory,
      'SPARK_YARN_APP_NAME' => node.spark.yarn_app_name,
      'SPARK_YARN_QUEUE' => node.spark.yarn_queue,
      'SPARK_YARN_DIST_FILES' => node.spark.yarn_dist_files,
      'SPARK_YARN_DIST_ARCHIVES' => node.spark.yarn_dist_archives,
      'SPARK_MASTER_IP' => node.spark.master_ip,
      'SPARK_MASTER_PORT' => node.spark.master_port,
      'SPARK_MASTER_OPTS' => node.spark.master_opts,
      'SPARK_MASTER_WEBUI_PORT' => node.spark.master_webui_port,
      'SPARK_WORKER_CORES' => node.spark.worker_cores,
      'SPARK_WORKER_MEMORY' => node.spark.worker_memory,
      'SPARK_WORKER_PORT' => node.spark.worker_port,
      'SPARK_WORKER_INSTANCES' => node.spark.worker_instances,
      'SPARK_WORKER_DIR' => node.spark.worker_dir,
      'SPARK_WORKER_OPTS' => node.spark.worker_opts,
      'SPARK_WORKER_WEBUI_PORT' => node.spark.worker_webui_port,
      'SPARK_HISTORY_OPTS' => node.spark.history_opts,
      'SPARK_DAEMON_JAVA_OPTS' => node.spark.daemon_java_opts,
      'SPARK_DAEMON_MEMORY' => node.spark.daemon_memory
    }
  })
end

template "#{node.spark.home}/conf/spark-defaults.conf" do
  source "spark-defaults.conf.erb"
  mode 0755
  owner node.spark.username
  group node.spark.username
  variables({
    :spark_props => {
      'spark.reducer.maxSizeInFlight' => node.spark.conf.reducer_max_inflight,
      'spark.shuffle.compress' => node.spark.conf.shuffle_compress,
      'spark.shuffle.consolidateFiles' => node.spark.conf.shuffle_consolidate_files,
      'spark.shuffle.file.buffer' => node.spark.conf.shuffle_file_buffer,
      'spark.shuffle.io.maxRetries' => node.spark.conf.shuffle_max_retries,
      'spark.shuffle.io.numConnectionsPerPeer' => node.spark.conf.shuffle_num_connections_per_peer,
      'spark.eventLog.enabled' => node.spark.conf.eventlog,
      'spark.eventLog.compress' => node.spark.conf.compress_eventlog,
      'spark.history.fs.logDirectory' => node.spark.conf.history_log_dir,
      'spark.shuffle.io.preferDirectBufs' => node.spark.conf.shuffle_direct_bufs,
      'spark.shuffle.io.retryWait' => node.spark.conf.shuffle_retry_wait,
      'spark.shuffle.memoryFraction' => node.spark.conf.shuffle_memory_fraction,
      'spark.shuffle.sort.bypassMergeThreshold' => node.spark.conf.shuffle_sort_bypass_merge_threshold,
      'spark.shuffle.spill' => node.spark.conf.shuffle_spill,
      'spark.shuffle.spill.compress' => node.spark.conf.shuffle_spill_compress,
      'spark.akka.frameSize' => node.spark.conf.akka_framesize
    }
  })
end

template "#{node.spark.home}/conf/metrics.properties" do
  source "metrics.properties.erb"
  mode 0755
  owner node.spark.username
  group node.spark.username
  variables({
    :hostname => node['hostname'],
    :graphite_host => node['spark']['graphite_host'],
    :graphite_port => node['spark']['graphite_port']
  })
end

template "/etc/security/limits.d/#{node.spark.username}.conf" do
  source "spark-limits.conf.erb"
  mode 0644
end

data = data_bag_item('spark', 'ssh_keys')
raise 'Could not find spark ssh_key data bag' if data.nil?

directory "#{node.spark.home}/.ssh" do
  owner node.spark.username
  group node.spark.username
end

public_ssh_key = data['public']
raise 'Could not find spark ssh_key public data bag item' if public_ssh_key.nil?
file "#{node.spark.home}/.ssh/authorized_keys" do
  owner node.spark.username
  group node.spark.username
  mode '0600'
  content public_ssh_key
end
