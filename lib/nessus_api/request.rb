require 'uri'
require 'net/http'
require 'nokogiri'

module NessusAPI
    class Session
        ##
        # Class that sends requests and stores
        # XML information.

        def initialize(host, login, password, port=8834)
            ##
            # Attempts to login and store all relevant
            # information about the login.
            # Will raise an error if no connection
            # can be found.
            @host = host
            @port = port.to_s
            data = {'login' => login, 'password' => password}
            request = get('login', data, false)
            @token = request.xpath("//contents/token").content
        end

        def get(function, args={}, token=true, host=@host)
            ##
            # Adds expected data to the arguments
            # and then makes a HTTP request.
            if token
                args['token'] = @token
            end
            args['seq'] = Random.new.rand(9999)
            url = URI('https://' + host + ':' + port + '/' + function)
            Net::HTTP.start(uri.host, uri.port,
                :use_ssl => uri.scheme == 'https') do |http|
                request = Net::HTTP::Post.new(url)
                request.set_form_data(args)
                response = http.request(request)
            end

            if response.is_a?(Net::HTTPSuccess)
                response_xml = Nokogiri::XML(response)
                if response_xml.xpath("//seq").content != seq
                    Log.error("Sequence doesn't match between request and response")
                    raise
                elsif response_xml.xpath("//status").content != 'OK'
                    Log.error("Request was not completed")
                    raise
                else
                    return response_xml
                end
            else
                Log.error('Cannot connect to Nessus installation')
                raise
            end
        end

        def close
            ##
            # Logs out of Nessus installation
            get('logout')
        end
    end
end 
