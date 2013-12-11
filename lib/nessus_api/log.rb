require 'rainbow'

module NessusAPI
    class Log
        def say(msg=nil)
            STDERR.puts msg
        end

        def self.error(msg=nil)
            say("ERROR: ".foreground(:red).bright + msg)
        end
    end
end
