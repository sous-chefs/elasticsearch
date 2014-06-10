use_inline_resources

def whyrun_supported?
  true
end

def exists?(url)
  begin
    uri = URI.parse(url)
    response = nil
    Net::HTTP.start(uri.host, uri.port) {|http|
      response = http.head(uri.path)
    }
    Chef::Log.debug("response: #{response.code} uri: #{uri} url: #{url}")
    response.code == "200"
  rescue
    false
  end
end

action :create do
  title = new_resource.title || new_resource.name
  source = new_resource.source

  report = title.gsub(/\s/, '_')
  doc_path = "/#{new_resource.index}/#{new_resource.type}/#{URI.escape(title)}"
  doc_url = "http://#{new_resource.es_host}:#{new_resource.es_port}#{doc_path}"
  tmp_file = "/tmp/#{report}.json"

  remote_file tmp_file do
    source "#{doc_url}/_source"
    action :create
    only_if { exists?(doc_url) }
  end

  if ::File.exist?(tmp_file)
    tmp_file_checksum = Chef::Digester.checksum_for_file(tmp_file)
  else
    tmp_file_checksum = 'tmp_file_checksum'
  end

  if ::File.exist?(source)
    source_checksum = Chef::Digester.checksum_for_file(source)
  else
    source_checksum = 'source_checksum'
  end

  Chef::Log.debug("tmp_file_checksum: #{tmp_file_checksum} source: #{source_checksum}")

  if tmp_file_checksum != source_checksum
    http_request title do
      url doc_url
      message lazy { ::File.open(source).read }
      action :put
      only_if { tmp_file_checksum != source_checksum }
    end
  end
end
