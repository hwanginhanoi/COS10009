require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1DB954)
BOTTOM_COLOR = Gosu::Color.new(0xFF1ED760)
SCREEN_HEIGHT = 800
SCREEN_WIDTH = 600 
XPOS = 250

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp 
	def initialize(file)
		@bmp = Gosu::Image.new(file)
	end
end

class Album
attr_accessor :title, :artist, :artwork, :tracks
	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@tracks = tracks
    @artwork = artwork
	end
end

class Track
	attr_accessor :name, :location, :dimension
	def initialize(name, location, dimension)
		@name = name
		@location = location
    @dimension = dimension
	end
end

class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY
	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end

# Put your record definitions here

class MusicPlayerMain < Gosu::Window

	def initialize
	  super SCREEN_WIDTH, SCREEN_HEIGHT
	  self.caption = "Music Player"
    @album_font = Gosu::Font.new(20)
    @track_font = Gosu::Font.new(60)
    @album = read_album()  
    @track_playing = 0
    playTrack(@track_playing, @album)
	end

  # Reads in and returns a single track from the given file

  def read_track(music_file, index)
    name = music_file.gets.chomp()
    location = music_file.gets.chomp()

    leftX = XPOS
		topY = 400 + 100 * index
		rightX = leftX + @track_font.text_width(name)
		bottomY = topY + @track_font.height()
    dimension = Dimension.new(leftX, topY, rightX, bottomY)

    track = Track.new(name, location, dimension)

    return track
  end

    # Returns an array of tracks read from the given file

  def read_tracks(music_file)
    count = music_file.gets.chomp.to_i
    index = 0

    tracks = Array.new

    while count > index
      track = read_track(music_file, index)
      tracks << track
      index += 1
    end

    return tracks
  end

  def read_album()
    music_file = File.new("input.txt", "r")
    title = music_file.gets.chomp
    artist = music_file.gets.chomp
    artwork = ArtWork.new(music_file.gets.chomp)
    tracks = read_tracks(music_file)

    album = Album.new(title, artist, artwork.bmp, tracks)

    music_file.close

    return album
  end

  def draw_albums(album)
    @album.artwork.draw(175, 90 , ZOrder::UI, 1, 1)
    @album.tracks.each do |track|
      display_track(track)
    @album_font.draw(album.title, 180, 100, ZOrder::UI, 1, 1, Gosu::Color::BLACK)
    @album_font.draw(album.artist, 180, 120, ZOrder::UI, 1, 1, Gosu::Color::BLACK)
    end
  end

  def draw_current_playing(index)
		draw_rect(0, @album.tracks[index].dimension.topY, SCREEN_WIDTH, @track_font.height, 0xFF228B22, ZOrder::PLAYER)
	end

  def area_clicked(leftX, topY, rightX, bottomY)
		if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
			return true
    else
      return false
    end
	end

  def display_track(track)
		@track_font.draw(track.name, XPOS, track.dimension.topY, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def playTrack(track, album)
    @song = Gosu::Song.new(album.tracks[track].location)
    @song.play(false)
  end

  def draw_background
    draw_quad(0,0, TOP_COLOR, 0, SCREEN_HEIGHT, TOP_COLOR, SCREEN_WIDTH, 0, BOTTOM_COLOR, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND)
	end
  
  def update
		unless @song.playing?
			@track_playing = (@track_playing + 1) % @album.tracks.length
			playTrack(@track_playing, @album) 
		end
	end

  def draw
    draw_background()
    draw_albums(@album)
    draw_current_playing(@track_playing)
	end

  def needs_cursor?; true; end

  def button_down(id)
		case id
	    when Gosu::MsLeft
	    	for index in 0...@album.tracks.length()
		    	if area_clicked(@album.tracks[index].dimension.leftX, @album.tracks[index].dimension.topY, @album.tracks[index].dimension.rightX, @album.tracks[index].dimension.bottomY)
		    		playTrack(index, @album)
		    		@track_playing = index
		    		break
		    	end
		    end
	    end
	end
end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0