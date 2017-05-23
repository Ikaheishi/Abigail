require './lib/BotInstance.rb'

class BotManager

	def initialize(botDirectoryPath = "bots")
		@bots = Array.new(0)
		@botNames = Hash.new
		@botDirectory = Dir.open(botDirectoryPath).seek 2
		while (dir = @botDirectory.read) != nil
			if File.file?("bots/#{dir}/bot.yaml")
				@botNames.store(dir,@bots.push(BotInstance.new("bots/#{dir}/bot.yaml")).length-1)
			end
		end
	end
	def shutdown
		@bots.each {|bot| bot.stop}
	end
	def resolveName(name)
		raise ArgumentError.new("Bot '#{name}' does not exist.") unless @botNames.key? name
		return @bots[@botNames[name]]
	end
	def start(name)
		resolveName(name).start
	end
	def stop(name)
		resolveName(name).stop
	end
end #BotManager
