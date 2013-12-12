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
            def search(tag)
                return xml.xpath("//#{tag}").content
            end

            @id = search("policyID")
            @name = search("policyName")
            save()
        end

        def save
            self.all[@id] << self
        end

        def to_s
            return @name
        end

        def self.get(id)
            return self.all[id]
        end

        def self.all
            return @@policies
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
                return self.all
            rescue
                return false
            end
        end
    end
end
