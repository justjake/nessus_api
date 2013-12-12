require 'test/unit'
require 'nessus_api'
require 'highline/import'

class TestNessusAPI < Test::Unit::TestCase
    def test_base_usage
        # First, I'll connect to the Nessus installation
        host = ask("Host: ")
        user = ask("Username: ")
        password = ask("Password: ") {|q| q.echo = false}
        port = ask("Port: ")
        @session = NessusAPI::Session.new(host, user, password, port)
        # Then, I'll have to be able to find all of the policies available.
        policies = NessusAPI::Template.collect(@session)
        say(policies)
        # Assume that we pick the first policy.
        policy = policies.keys[0]
        # Now we need to create a scan using this policy...
        scan = NessusAPI::Template.new("New Test Scan", policy, "127.0.0.1")
        # We have our template set up, so now we need to set a time.
        scan.time = Time.now + 3600*24
        say(scan.to_hash)
        assert_equal(scan.save, true, "Saving isn't working")
    end

    def test_request
        # More tests should probably go here...
        # Look into forging responses.
    end

    def test_policy
#        NessusAPI::Policy.collect(@session)
#        assert_not_equal(NessusAPI::Policy.all, {}, "Templates not saving")
#        NessusAPI::Policy.clear
#        assert_equal(NessusAPI::Policy.all, {}, "Templates not clearing")
#        policy_xml = <<-eos
#            <policy>
#            <policyID>8</policyID>
#            <policyName>Scan Policy</policyName>
#            <policyOwner>admin</policyOwner>
#            <visibility>private</visibility>
#            <policyContents>
#            <policyComments></policyComments>
#            <Preferences>
#            <ServerPreferences>
#            <preference>
#            <name>use_mac_addr</name>
#            <value>no</value>
#            </preference>
#            </ServerPreferences>
#            </Preferences>
#            <PluginName>Nessus TCP scanner</PluginName>
#            <Family>Port scanners</Family>
#            <Status>enabled</Status>
#            </PluginItem></IndividualPluginSelection>
#            </policyContents>
#            </policy>
#        eos
#        policy_xml = Nokogiri::XML(policy_xml)
#        policy = NessusAPI::Policy.new(policy_xml)
#        assert_equal(policy.id, "8", "XML parsing isn't correct")
#        assert_equal(policy.name, "Scan Policy", "XML parsing isn't correct")
#        assert_equal(NessusAPI::Policy.get("8"), policy, "Saving isn't accurately matching id's to instances")
#        assert_equal(policy.to_s, "Scan Policy", "String representation of policy isn't its name")
    end

    def test_template
    end

    def test_logging
    end
end
