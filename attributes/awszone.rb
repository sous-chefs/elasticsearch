require 'open-uri'

def awszone
    begin
        normal[:elasticsearch][:node][:awszone] = open('http://169.254.169.254/latest/meta-data/placement/availability-zone'){|f| f.gets}
    rescue OpenURI::HTTPError => error
        response = error.io
    end
end
