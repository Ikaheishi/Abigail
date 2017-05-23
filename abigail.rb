#!/bin/ruby
# Abigail — A chat bot for Discord
# Copyright 2017 Ikaheishi

require './lib/BotManager.rb'
continue = true
@manager = BotManager.new()

while continue
	print "Abigail> "
	command = gets.split(/[[:space:]]/)
	if command[0] != nil
		case command[0]
		when 'exit'
			continue = false
		when 'run','start'
			if command[1] != nil
				begin
					@manager.start(command[1])
				rescue ArgumentError => ex
					print ex
				end
			else
				puts "\tUsage: #{command[0]} <name>\n\nAttempts to start the specified bot."
			end
		when 'stop','halt'
			if command[1] != nil
				begin
					@manager.stop(command[1])
				rescue ArgumentError => ex
					print ex
				end
			else
				puts "\tUsage: #{command[0]} <name>\n\nStops the given bot if it is already running."
			end
		end
	end
end

@manager.shutdown
