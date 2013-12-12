require 'nokogiri'

module NessusAPI
    class Policy
        ##
        # Class that interacts with policies
        # defined in the Nessus installation.

        @@policies = {}

        def initialize(id, name)
            ##
            # Takes individual XML from a server response
            # and translates it into a single object.
            # Adds the object to policies hash.
            @id = id
            @name = name
            save()
        end

        def save
            @@policies[@id] = self
        end

        def to_s
            return @name
        end

        def self.get(id)
            return @@policies[id]
        end

        def self.clear
            @@policies = {}
        end

        def self.collect(session)
            ##
            # Connects to the Nessus server and separates
            # the resulting XML response into individual
            # policies that are then turned into objects.
            begin
                response = session.get('policy/list')
                response.css('policy').each do |p|
                    Policy.new(p.css('policyID').text, p.css('policyName').text)
                end
                return @@policies
            rescue
                return false
            end
        end
    end
end
