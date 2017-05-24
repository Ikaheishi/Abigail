require 'discordrb'
require 'yaml'

class BotInstance
	def initialize(botDirectory)
		@directory = botDirectory
		@name = botDirectory[botDirectory.rindex(/(\/|\\)/)+1..-1]
		@config = File.open("#{botDirectory}/bot.yaml") {|file| YAML.load(file)}
		if @config['type'] == 'discord'
			@bot = Discordrb::Bot.new token: @config['token'], client_id: @config['id']
		else
			raise "Invalid bot type #{@config['type']}!"
		end
		@bot.name = "Abigail (http://ikaheishi.net/abigail, 0.0.1dev)"
		@status = :inactive
	end
	def name
		return @name
	end
	def type
		return @bot.class
	end
	def status
		return @status
	end
	def start
		@bot.run :async
		@status = :active
	end
	def stop
		@bot.stop if @status == :active
		@status = :inactive
	end
	def say(channel, message)
		@bot.send_message(channel, message)
	end
end
