require File.expand_path("../lib/nessus_api/version", __FILE__)

Gem::Specification.new do |s|
    s.name          = 'nessus_api'
    s.version       = NessusAPI::VERSION
    s.date          = Date.today.to_s

    s.summary       = "Allows interaction with Nessus REST API."
    s.description   = "Intelligently allows for use of Nessus API, both with gathering and editing information."

    s.authors       = "Nicholas Wold"
    s.email         = "nicholas.wold@berkeley.edu"
    s.homepage      = "http://www.nicholaswold.com"

    s.add_dependency('rainbow')
    s.add_dependency('nokogiri')

    s.files = Dir['{bin,lib,man,test,spec}/**/*', 'README*',
        'LICENSE*'] & `git ls-files -z`.split("\0")
end
