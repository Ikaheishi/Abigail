#!/bin/ruby
# Abigail — A chat bot for Discord
# Copyright 2017 Ikaheishi

require_relative 'lib/BotManager'
require_relative 'lib/Prompt'

continue = true
@manager = BotManager.new()

while continue
	print "Abigail> "
	command = Prompt::tokenize(gets)

	next if command[0] == nil

	begin
		case command[0]
		when 'exit'
			continue = false
		when 'status'
			@manager.status(command[1..-1])
		when 'run','start'
			if command[1] != nil
				@manager.start(command[1])
			else
				puts "\tUsage: #{command[0]} <name>\n\nAttempts to start the specified bot."
			end
		when 'stop','halt'
			if command[1] != nil
				@manager.stop(command[1])
			else
				puts "\tUsage: #{command[0]} <name>\n\nStops the given bot if it is already running."
			end
		when 'manual'
			if command[1] != nil
				command[1] == '-a' ? @manager.manual_adv(command[2]) : @manager.manual(command[1])
			else
				puts "\tUsage: #{command[0]} <name>\n\nSwitches the specified bot into manual control mode."
			end
		end
	rescue ArgumentError => ex
		puts ex
	rescue NotImplementedError
		puts "Sorry, but that function is not yet implemented."
	end
end

@manager.shutdown
