require 'nokogiri'

module NessusAPI
    class Policy
        ##
        # Class that interacts with policies
        # defined in the Nessus installation.

        @@policies = {}

        def initialize(xml)
            ##
            # Takes individual XML from a server response
            # and translates it into a single object.
            # Adds the object to policies hash.
            @id = xml.xpath("//policyID")[0].content
            @name = xml.xpath("//policyName")[0].content
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
                response.xpath("//policy").each do |policy|
                    Policy.new(policy)
                end
                return @@policies
            rescue
                return false
            end
        end
    end
end
