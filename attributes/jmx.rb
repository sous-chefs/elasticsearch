#==== JMX CONFIGURATION
default.elasticsearch[:jmx_config][:port] = 3333
default.elasticsearch[:jmx_config][:ssl] = false
default.elasticsearch[:jmx_config][:authenticate] = false
default.elasticsearch[:jmx_config][:hostname_fqdn] = false
default.elasticsearch[:jmx_config][:password_file] = ""
default.elasticsearch[:jmx_config][:access_file] = "" 

default.elasticsearch[:jmx_config][:keystore] = ""
default.elasticsearch[:jmx_config][:keystorepassword]  = ""
default.elasticsearch[:jmx_config][:truststore] = ""
default.elasticsearch[:jmx_config][:truststorepassword] = ""
default.elasticsearch[:jmx_config][:nedd_client_auth]  = true
