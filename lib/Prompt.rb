module Prompt
	def tokenize(input)
		result = Array.new(0)

		in_string = nil
		escape = nil
		token = ''

		input.chomp!.each_char {|char|
			unless escape
				case char
				when "\\"
					escape = true if in_string == 1
				when '"'
					in_string == 1 ? in_string = nil : in_string = 1
					next
				when "'"
					in_string == 2 ? in_string = nil : in_string = 2
					next
				when /\s/
					unless in_string
						result.push process(token)
						token = ''
						next
					end
				end
			end
			token.concat char
		}
		result.push process(token)

		return result
	end
	module_function :tokenize
	def process(string)
		return string.match(/^[0-9]+$/) ? string.to_i : string
	end
	module_function :process
end