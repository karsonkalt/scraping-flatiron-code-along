class CLI
    def initialize
        puts ''
        puts ''
        puts ' ____      _   ____   ___   ___ _____ _   _ '.colorize(:blue)
        puts '|  _ \    | | | __ ) / _ \ / _ \_   _| | | |'.colorize(:blue)
        puts '| | | |_  | | |  _ \| | | | | | || | | |_| |'.colorize(:blue)
        puts '| |_| | |_| | | |_) | |_| | |_| || | |  _  |'.colorize(:blue)
        puts '|____/ \___/  |____/ \___/ \___/ |_| |_| |_|'.colorize(:blue)
    end
    
    def puts_announcement(arg)
        puts ""
        puts arg.upcase.colorize(:blue)
        length = arg.split("").count
        (1..length).each do |num|
            print "-"
        end
        puts ""
    end
    
    def puts_main_menu
        puts_announcement("Main Menu")
        puts ""
        puts "There are " + Track.all.count.to_s.colorize(:blue) + " tracks in the program."
        puts ""
        puts "Add"
        puts "---"
        puts "A".colorize(:green) + "  - Add tracklist"
        puts "AD".colorize(:green) + " - Bulk add tracklists (takes 60 seconds)"
        puts ""
        puts "View"
        puts "----"
        puts "TL".colorize(:green) + " - Tracklists"
        puts "UR".colorize(:green) + " - Unreleased tracks"
        puts "UN".colorize(:green) + " - Unconfirmed tracks"
        puts ""
        puts "Search"
        puts "------"
        puts "S".colorize(:green) + "  - Search by Artist"
        puts ""
        puts "E".colorize(:green) + "  - Exit"
    end
    
    def input_loop
        puts_main_menu
        input = gets.chomp
    
        if input.upcase == "A"
            puts ""
            puts "Enter the URL of a tracklist to add."
            tracklist = Tracklist.new
            tracklist.page_input
            tracklist.make_tracks
            puts "Done".colorize(:green)
            input_loop
    
        elsif input.upcase == "AD"
            puts "Enter the URL of an Artist to add their most recent 25 tracklists."
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
            puts_announcement("View Tracklists")
            @counter = 0
            Tracklist.all.each do |tracklist|
                @counter += 1
                puts "#{@counter}. #{tracklist.title}"
            end
            puts ""
            def tracklist_loop
                puts "Enter a tracklist number to view tracks or type " + "BACK".colorize(:red) + " to go back"
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
            puts_announcement("UNCONFIRMED TRACKS")
            unconfirmed_list = Track.all.select do |track|
                track.confirmation_status == "Unconfirmed"
            end
    
            unconfirmed_list.each do |track|
                puts "#{track.title} -- #{track.artist} played in #{track.tracklist.title} at #{track.timestamp}"
            end
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
                puts_announcement("TRACKS BY #{search_tracks.first.artist.upcase}")
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