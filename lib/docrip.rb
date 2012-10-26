require 'mechanize'
require 'json'
require 'awesome_print'

agent = Mechanize.new

# page = agent.get 'http://www.leadwerks.com/werkspace/page/Documentation/le2/_/command-reference/2d-drawing/drawimage-r20'
page = agent.get 'http://www.leadwerks.com/werkspace/page/Documentation/le2/_/command-reference/bodies/createbodyhull-r47'

query = '#content'

sections = []

def swallow
	begin
		yield
	rescue
		nil
	end
end

description = /Description(.*)Syntax/ixm
c_syntax = /Syntax.*C\:(.*)C\+\+/ixm
c_syntax2 = /Syntax.*C\:(.*)example/ixm
cpp_syntax = /c\+\+\:(.*)example/ixm

member = nil
page.search(query).each do |result|
	member = {
		description: swallow { description.match(result.text)[1].strip },
		c_syntax: swallow {
			m = c_syntax.match(result.text)
			if m && m.length > 0
				m = m[1].strip
			else
				m = c_syntax2.match(result.text)[1].strip
			end
			m
		},
		cpp_syntax: swallow { cpp_syntax.match(result.text)[1].strip },
		example: swallow { result.search('pre')[0].text }
	}
end
puts JSON.pretty_generate member

