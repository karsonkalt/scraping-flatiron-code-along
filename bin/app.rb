require 'nokogiri'
require 'open-uri'

require_relative '../lib/track.rb'
require_relative '../lib/tracklist.rb'
require_relative '../lib/scraper.rb'

def puts_main_menu
    puts ""
    puts "View:"
    puts "TL - Tracklists"
    puts "UR - Unreleased tracks"
    puts "UN - Unconfirmed tracks"
    puts "N  - Number of tracks"
    puts ""
    puts "Or:"
    puts "AD - Add new artist site and all sub tracklists"
    puts "A  - Add tracklist"
    puts "S  - Search"
    puts ""
    puts "E  - Exit"
end

def puts_announcement(arg)
    puts ""
    puts "----------------------"
    puts arg.upcase
    puts "----------------------"
    puts ""
end

def input_loop

    if Track.all.count == -1
        puts "Welcome"
        
        # puts "Please enter a website to scrape."
        # tracklist_1 = Tracklist.new
        # tracklist_1.page_input
        # tracklist_1.make_tracks
        # puts_announcement("Done")
        # input_loop

    else
        puts_main_menu
        input = gets.chomp

        if input.upcase == "A"
            puts "Please enter a website to scrape."
            tracklist_2 = Tracklist.new
            tracklist_2.page_input
            tracklist_2.make_tracks
            puts_announcement("Done")
            input_loop

        elsif input.upcase == "AD"
            puts "Please enter an artist name to search and scrape tracklists."
            Scraper.new.make_tracklists
            input_loop

        elsif input.upcase == "UR"
            puts_announcement("Unreleased Tracks")
            unreleased_list = Track.all.select do |track|
                track.label == "Unreleased"
            end
            id_counter = 0
            unreleased_list.each do |track|
                if track.title == "ID" && track.artist == "ID"
                    id_counter += 1
                else
                    puts "#{track.title} -- #{track.artist}"
                end
            end

            if id_counter > 0
                puts ""
                puts "There are also #{id_counter} ID's with no information."
            end
            input_loop

        elsif input.upcase == "E" || input.upcase == "EXIT"
            puts_announcement("Exiting")

        elsif input.upcase == "TL"
            puts_announcement("Tracklist")
            @counter = 0
            Tracklist.all.each do |tracklist|
                @counter += 1
                puts "#{@counter}. #{tracklist.title}"
            end
            puts ""
            def tracklist_loop
                puts "Enter a tracklist number to display or type BACK to go back"
                input = gets.chomp
                if input.upcase == "BACK"
                elsif input.to_i > 0 && input.to_i <= @counter
                    tracklist = Tracklist.all[input.to_i - 1]
                    tracklist.print_set
                else
                    puts "Invalid response."
                    tracklist_loop
                end
            end
            tracklist_loop
            input_loop

        elsif input.upcase == "UN"
            puts_announcement("Unconfirmed Tracks")
            unconfirmed_list = Track.all.select do |track|
                track.confirmation_status == "Unconfirmed"
            end

            unconfirmed_list.each do |track|
                puts "#{track.title} -- #{track.artist} played in #{track.tracklist.title} at #{track.timestamp}"
            end
            input_loop

        elsif input.upcase == "N"
            puts ""
            puts "There are #{Track.all.count} tracks in the program."
            input_loop

        elsif input.upcase == "S"
            puts ""
            puts "Enter an artist name to search for"
            input = gets.chomp
            puts ""
            search_tracks = Track.all.select do |track|
                track.artist.upcase == input.upcase
            end
            if search_tracks[0] != nil
                puts "----------------------"
                puts "TRACKS BY #{search_tracks.first.artist.upcase}"
                puts "----------------------"
                search_tracks.each do |track|
                    puts "#{track.title} -- #{track.label}"
                end
            else
                puts "No search results"
            end
            input_loop

        else
            puts ""
            puts "Invalid response"
            input_loop
        end
    end
end

puts ""
puts "----------------------"
puts " 1001 SCRAPE PROGRAM  "
puts "----------------------"
input_loop