require 'discordrb'
require 'yaml'

class BotInstance
	def initialize(config_file)
		@config = File.open(config_file) {|file| YAML.load(file)}
		if @config['type'] == 'discord'
			@bot = Discordrb::Bot.new token: @config['token'], client_id: @config['id']
		else
			raise "Invalid bot type #{@config['type']}!"
		end
		@bot.name = "Abigail (http://ikaheishi.net/abigail, 0.0.1dev)"
	end
	def start
		@bot.run :async
	end
	def stop
		@bot.stop
	end
	def say(channel, message)
		@bot.send_message(channel, message)
	end
end
