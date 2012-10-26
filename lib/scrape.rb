require 'mechanize'
require 'json'
require 'awesome_print'

agent = Mechanize.new

page = agent.get('http://www.leadwerks.com/werkspace/page/Documentation/le2/_/command-reference/')
query = '#content > a'

sections = []

def get_member member
	agent = Mechanize.new
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

	member_data = nil
	member_page = agent.get member[:href]
	member_page.search(query).each do |result|
		member_data = {
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
	member_data
end

page.search(query).each do |i|
	sections << {
		name: i.text,
		href: i[:href],
		members: []
	}
end

sections.each do |s|
	section_page = agent.get(s[:href])
	section_page.search(query).each do |i|
		member = {
			name: i.text,
			href: i[:href]
		}
		member_data = get_member(member) || {}
		member.merge! member_data
		s[:members] << member
	end
end

puts JSON.pretty_generate sections
