class Track
    attr_accessor :title, :artist, :label, :timestamp, :number, :confirmation_status, :spotify_info, :tracklist

    @@all = []

    def initialize
        @@all << self
    end

    def self.all
        @@all
    end

    def self.reset_all
        @@all.clear
    end
end

