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
            @token = request.xpath("//token")[0].content
        end

        def get(function, args={}, token=true, host=@host, port=@port)
            ##
            # Adds expected data to the arguments
            # and then makes a HTTP request.
            if token
                args['token'] = @token
            end
            seq = Random.new.rand(9999).to_s
            args['seq'] = seq
            url = URI('https://' + host + ':' + port + '/' + function)
            request = Net::HTTP::Post.new(url.path)
            request.set_form_data(args)
            conn = Net::HTTP.new(url.host, url.port)
            conn.use_ssl = true
            conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = conn.request(request)

            if response.is_a?(Net::HTTPSuccess)
                response_xml = Nokogiri::XML(response.body)
                if response_xml.xpath("//seq")[0].content != seq
                    Log.error("Sequence doesn't match between request and response")
                    raise
                elsif response_xml.xpath("//status")[0].content != 'OK'
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
