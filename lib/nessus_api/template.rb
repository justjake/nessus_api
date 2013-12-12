module NessusAPI
    class Template
        ##
        # The class that handles templated scans.
        
        def initialize(template_name, policy_id, target)
            @name = template_name
            @policy = policy_id
            @target = target
            @time = nil
            @freq = 'ONETIME'
            @interval = nil
        end

        def to_hash
            results = {"template_name" => @name, "policy_id" => @policy,
                "target" => @target}
            if !@time.nil?
                results['startTime'] = @time.strftime("%Y%m%dT%H%M%S")
            end
            rules = "FREQ=#{@freq}"
            if !@interval.nil?
                rules += ";INTERVAL=#{@interval}"
            end
            results['rRules'] = rules
            return results
        end

        def save(session)
            begin
                response = session.get('scan/template/new', to_hash())
                return response.xpath("//name").content
            rescue
                return false
            end
        end
    end
end
