#!/bin/ruby
# Abigail — A chat bot for Discord
# Copyright 2017 Ikaheishi

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
	end
	def start
		@bot.run :async
	end
	def stop
		@bot.stop
	end
end

bots = Array.new(0)
botNames = Hash.new

botDirectory = Dir.open("bots").seek 2
while (dir = botDirectory.read) != nil
	if File.file?("bots/#{dir}/bot.yaml")
		botNames.store(dir,bots.push(BotInstance.new("bots/#{dir}/bot.yaml")).length-1)
	end
end

continue = true

while continue
	print "Abigail> "
	command = gets.split(/[[:space:]]/)
	if command[0] != nil
		case command[0]
		when 'exit'
			continue = false
		when 'run','start'
			if command[1] != nil
				bots[botNames[command[1]]].start if botNames.key?(command[1])
			else
				puts "Can not start '#{command[1]}': No such bot exists."
			end
		when 'stop','halt'
			if command[1] != nil
				bots[botNames[command[1]]].stop if botNames.key?(command[1])
			else
				puts "Can not stop '#{command[1]}': No such bot exists."
			end
		else
			puts "Unknown command '#{command[0]}'."
		end
	end
end
