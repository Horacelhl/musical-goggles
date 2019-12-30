require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# Put your record definitions here
class Track
	attr_accessor :name, :location
	def initialize (name, location)
		@name = name
		@location = location
	end
end

class Album
	attr_accessor :id, :title, :artist, :tracks

	def initialize (id, title, artist, tracks)
    @id = id
		@title = title
		@artist = artist
		@tracks = tracks
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 1000, 700
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
      @background = Gosu::Color::WHITE
      @play = -1
  		@albums = read_albums_file()

  		@album1 = Gosu::Image.new("images/June.jpg")
  		@album2 = Gosu::Image.new("images/July.jpg")
  		@album3 = Gosu::Image.new("images/August.jpg")
  		@album4 = Gosu::Image.new("images/September.jpg")
      @selection = -1


      @font = Gosu::Font.new(20)

	end

def read_track(music_file)
	  name = music_file.gets.chomp
    location = music_file.gets.chomp
	  track = Track.new(name, location)
    return track
end

def read_tracks(music_file)
    number_of_tracks = music_file.gets.to_i
    tracks = Array.new()
    for i in 0..(number_of_tracks-1)
        tracks << read_track(music_file)
    end
    return tracks
end

  #read the data from file and insert to array

  #load the albums data from textfile
  def read_albums_file()
  	music_file = File.new("albums.txt","r")
    albums = read_albums(music_file)
    music_file.close()
		return albums
  end

  def read_album(music_file)
  		album = Album.new(music_file.gets, music_file.gets, music_file.gets, read_tracks(music_file))
  		return album
  end

  def read_albums music_file
    number_of_albums = music_file.gets().to_i
		albums = Array.new()
		for i in 1..number_of_albums
			album = read_album(music_file)
			albums << album
		end
		return albums
  end


  def draw_albums

    @album1.draw(10,10,ZOrder::UI, scale_x = 0.7, scale_y = 0.7)
    @album2.draw(310,10,ZOrder::UI, scale_x = 0.7, scale_y = 0.7)
    @album3.draw(10,310,ZOrder::UI, scale_x = 0.7, scale_y = 0.7)
    @album4.draw(310,310,ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

    if @selection > -1
      index = 0
      pY = 50
      while index < 15
      display_track(@albums[@selection].tracks[index].name,pY)
      index += 1
      pY += 30
      end
    end
  end

  def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
    if (mouse_x >= leftX) and (mouse_x <= rightX) and (mouse_y >= topY) and (mouse_y <= bottomY)
      true
    else
      false
    end
  end

  def display_track(title, ypos)
  	@font.draw(title, 630, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def playTrack(track)

  			@song = Gosu::Song.new(@albums[@selection].tracks[track].location)
  			@song.play(false)

  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
     Gosu.draw_rect(0, 0, 1000, 700, @background, ZOrder::BACKGROUND, mode=:default)
	end


	def update

	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background
		draw_albums
    if @play > -1
    @font.draw("Now playing...\n#{@albums[@selection].tracks[@play].name}", 650, 550, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end

	end

 	def needs_cursor?; true; end

	def button_down(id)
    index = 0
    x = 50
    y = 80
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
        if area_clicked(10,10,300,290)
           @selection = 0
           @background = Gosu::Color::GREEN
        end

        if area_clicked(310,10,600,290)
           @selection = 1
           @background = Gosu::Color::BLUE
        end

        if area_clicked(10,310,300,590)
           @selection = 2
           @background = Gosu::Color::RED
        end

        if area_clicked(310,310,600,590)
           @selection = 3
           @background = Gosu::Color::YELLOW
        end

          for index in 0..14
            if area_clicked(630,x,980,y)
                playTrack(index)
                @play = index
              end
            index +=1
            x +=30
            y +=30
          end


      end
	  end
end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
