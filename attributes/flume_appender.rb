
default.flume[:logging][:flume_appender_common][:version]       = "0.1.4"
default.flume[:logging][:flume_appender_common][:url]           = "http://jcenter.bintray.com/com/gilt/flume/logging-flume-commons/#{node.flume[:logging][:flume_appender_common][:version]}/logging-flume-commons-#{node.flume[:logging][:flume_appender_common][:version]}.jar"

default.flume[:logging][:flume_appender_logback][:version]      = "0.1.4"
default.flume[:logging][:flume_appender_logback][:url]          = "http://jcenter.bintray.com/com/gilt/flume/logback-flume-appender/#{node.flume[:logging][:flume_appender_logback][:version]}/logback-flume-appender-#{node.flume[:logging][:flume_appender_logback][:version]}.jar"

default.flume[:logging][:flume_agents] = nil
default.flume[:logging][:properties] = nil
