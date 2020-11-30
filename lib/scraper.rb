class Scraper

    def get_page
        input = gets.chomp
        Nokogiri::HTML(open(input, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36'))
    end

    def get_tracklists
        self.get_page.css(".tl")
    end

    def make_tracklists
        self.get_tracklists.each do |tracklist|
            sleep(3)
            local_link = tracklist.css(".tlLink a")[0]["href"]
            url = "http://1001tracklists.com#{local_link}"
            tl = Tracklist.new
            tl.page_scraped(url)
            print tl.title
            tl.make_tracks
        end
    end
end

