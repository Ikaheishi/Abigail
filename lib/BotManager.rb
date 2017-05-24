require_relative 'BotInstance'
require_relative 'Prompt'

class BotManager

	def initialize(botDirectoryPath = "bots")
		@bots = Array.new(0)
		@botNames = Hash.new
		@botDirectory = Dir.open(botDirectoryPath).seek 2
		while (dir = @botDirectory.read) != nil
			next if dir[0] == '.'
			if File.file?("bots/#{dir}/bot.yaml")
				@botNames.store(dir,@bots.push(BotInstance.new("bots/#{dir}")).length-1)
			end
		end
	end
	def shutdown
		@bots.each {|bot| bot.stop}
	end
	def resolve_name(name)
		raise ArgumentError.new("Bot '#{name}' does not exist.") unless @botNames.key? name
		return @bots[@botNames[name]]
	end
	def status(bots = [])
		bot_info = Array.new
		if bots[0] == nil
			i = 0
			@bots.length.times{
				bots.push i
				i+=1
			}
		end

		bots.each {|bot|
			case bot.class.inspect
			when 'String'
				id = resolve_name(bot)
				hash = Hash.new

				hash['id'] = id
				hash['name'] = bot
				hash['type'] = @bots[id].type
				hash['status'] = @bots[id].status

				bot_info.push hash
			when 'Fixnum'
				hash = Hash.new

				hash['id'] = bot
				hash['name'] = @bots[bot].name
				hash['type'] = @bots[bot].type
				hash['status'] = @bots[bot].status

				bot_info.push hash
			end
		}

		puts " BOT #\t|NAME\t\t|TYPE\t\t|STATUS"
		bot_info.each {|bot| printf(" % 5d\t|%-15s|%-15s|%-10s\n",bot['id'],bot['name'],bot['type'],bot['status'])}
	end
	def start(name)
		resolve_name(name).start
	end
	def stop(name)
		resolve_name(name).stop
	end
	def manual(name)
		raise NotImplementedError
	end
	def manual_adv(name)
		bot = resolve_name(name)
		while true
			begin
				print "BotInstance:#{name}>"
				command = Prompt::tokenize(gets)
				puts command.inspect
				return if command[0].match(/exit/)
				if command[0].match(/h(e?l)?p/)
					puts bot.method(command[1]).parameters
					next
				end
				if bot.method(command[0]).parameters.length == 0
					proc = bot.method(command[0]).call
				else
					proc = bot.method(command.shift).curry
					proc = proc.call(command.shift) while command.length >= 1
				end
				puts "=> #{proc}"
			rescue NameError, ArgumentError => ex
				puts ex
			end
		end
	end
end #BotManager
