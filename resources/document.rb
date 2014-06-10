actions :create
default_action :create

attribute :title, :kind_of => String
attribute :source, :kind_of => String
attribute :es_host, :kind_of => String
attribute :es_port, :kind_of => Integer, :default => 9200
attribute :index, :kind_of => String
attribute :type, :kind_of => String

