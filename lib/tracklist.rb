class Tracklist

  attr_accessor :title, :artist, :date, :tracks_in_tracklist

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def page_input
    @input = gets.chomp
  end

  def page_scraped(var)
    @input = var
  end

  def get_page
    doc = Nokogiri::HTML(open(@input))
    self.title = doc.css("#pageTitle").text
    doc
  end 

  def get_tracks
    self.get_page.css(".tlpItem")
  end 

  def make_tracks
    #Variable to use if mashup track
    mashup_number = 0

    self.get_tracks.each do |post|
      print "."
      track = Track.new
      track.tracklist = self

      #Variables to be parsed
      track_info = post.css(".trackFormat").css(".notranslate").text
      track_label = post.css(".trackLabel").text.split(/\[|\]/)
      track_number = post.css(".tlFontLarge").text.strip.to_i

      #Assign to object
      track.artist = track_info.split(" - ")[0]
      track.title = track_info.split(" - ")[1]
      track.timestamp = post.css(".cueValueField").text.strip

      #If statements to assign to object
      if post.css(".tlUserInfo").text != ""
        track.confirmation_status = "Confirmed"
      else
        track.confirmation_status = "Unconfirmed"
      end

      #If a mashup track, use the track number of previously played track
      if track_number != 0
        track.number = track_number
        mashup_number = track_number
      else
        track.number = mashup_number
      end

      if track_label[1] != nil
        track_label_original = track_label[1].split
        track_label_capitalize = track_label_original.collect do |word|
          word.capitalize
        end
        track.label = track_label_capitalize.join(" ")
      else
        track.label = "Unreleased"
      end

    end
    puts ""
  end 

  def print_set
    puts ""
    puts "-------------------------------"
    puts self.title.upcase
    puts "-------------------------------"
    puts ""

    mashup_number = 0
    
    tracks_in_set = Track.all.select do |track|
      track.tracklist == self
    end
    
    tracks_in_set.each do |track|
      spacer = ""

      if track.number != mashup_number
        mashup_number = track.number
        puts "Track #{track.number}"
      else
        spacer = "  "
        puts "#{spacer}Track played together with previous track"
      end

      if track.timestamp != ""
        puts "  #{spacer}Cue: #{track.timestamp}"
      else
        puts "  #{spacer}No cue time"
      end

      puts "  #{spacer}Title: #{track.title}"
      puts "  #{spacer}Artist: #{track.artist}"
      puts "  #{spacer}Label: #{track.label}"
      puts "  #{spacer}Confirmation Status: #{track.confirmation_status}"
      puts ""
    end
  end
  
end