require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1DB954)
BOTTOM_COLOR = Gosu::Color.new(0xFF1ED760)
SCREEN_WIDTH = 450
SCREEN_HEIGHT = 600
XPOS = 270		# x-location to display track's name

module ZOrder
	BACKGROUND, PLAYER, UI = *0..2
end

module Genre
	POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp, :dimension

	def initialize(file, leftX, topY)
		@bmp = Gosu::Image.new(file)
		@dimension = Dimension.new(leftX, topY, leftX + @bmp.width(), topY + @bmp.height())							
	end
end

class Album
	attr_accessor :title, :artist, :artwork, :tracks

	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
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


class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_WIDTH, SCREEN_HEIGHT
	    self.caption = "Music Player"
	    @track_font = Gosu::Font.new(25)
	    @albums = read_albums()
	    @album_playing = -1
	    @track_playing = -1
	end

  	# Read a single track
	def read_track(music_file, index)
		track_name = music_file.gets.chomp
		track_location = music_file.gets.chomp

		leftX = XPOS
		topY = 50 * index + 30
		rightX = leftX + @track_font.text_width(track_name)
		bottomY = topY + @track_font.height()
		dimension = Dimension.new(leftX, topY, rightX, bottomY)

		track = Track.new(track_name, track_location, dimension)
		return track
	end

	# Read all tracks of an album
	def read_tracks(music_file)
		count = music_file.gets.chomp.to_i
		tracks = []

		index = 0
		while index < count
			track = read_track(music_file, index)
			tracks << track
			index += 1
		end
		# --- Return the tracks array ---
		return tracks
	end

	# Read a single album
	def read_album(music_file, index)
		title = music_file.gets.chomp
		artist = music_file.gets.chomp

		leftX = 30
		topY = 30 + 130 * index
		artwork = ArtWork.new(music_file.gets.chomp, leftX, topY)

		tracks = read_tracks(music_file)
		album = Album.new(title, artist, artwork, tracks)
		return album
	end

	# Read all albums
	def read_albums()
		music_file = File.new("input.txt", "r")
		count = music_file.gets.chomp.to_i
		albums = Array.new()

		index = 0
		while index < count
			album = read_album(music_file, index)
			albums << album
			index += 1
	  	end

		music_file.close()
		return albums
	end

	# Draw albums' artworks
	def draw_albums(albums)
		albums.each do |album|
			album.artwork.bmp.draw(album.artwork.dimension.leftX, album.artwork.dimension.topY , ZOrder::UI)
		end
	end

	# Draw tracks' titles of a given album
	def draw_tracks(album)
		album.tracks.each do |track|
			display_track(track)
		end
	end

	def draw_albums_area
		Gosu.draw_rect(0, 0, 160, SCREEN_HEIGHT, 0xFF3bc639, ZOrder::PLAYER)
		Gosu.draw_rect(160, 0, 5, SCREEN_HEIGHT, Gosu::Color::WHITE, ZOrder::PLAYER)

	end

	# Draw indicator of the current playing song
	def draw_current_track_playing(index, album)
		draw_rect(160, album.tracks[index].dimension.topY - 5, SCREEN_WIDTH, @track_font.height + 10, 0xFF228B22, ZOrder::PLAYER)
	end

	# Detects if a 'mouse sensitive' area has been clicked on
	# i.e either an album or a track. returns true or false
	def area_clicked(leftX, topY, rightX, bottomY)
		if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
			return true
		else
			return false
		end
	end

	# Takes a String title and an Integer ypos
	# You may want to use the following:
	def display_track(track)
		@track_font.draw(track.name, XPOS, track.dimension.topY, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
	end


	# Takes a track index and an Album and plays the Track from the Album
	def playTrack(track, album)
		@song = Gosu::Song.new(album.tracks[track].location)
		@song.play(false)
	end

	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background()
		draw_quad(0,0, TOP_COLOR, 0, SCREEN_HEIGHT, TOP_COLOR, SCREEN_WIDTH, 0, BOTTOM_COLOR, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND)
	end

	# Not used? Everything depends on mouse actions.
	def update
		# If a new album has just been seleted, and no album was selected before -> start the first song of that album
		if @album_playing >= 0 && @song == nil
			@track_playing = 0
			playTrack(0, @albums[@album_playing])
		end
		
		# If an album has been selecting, play all songs in turn
		if @album_playing >= 0 && @song != nil && (not @song.playing?) && (not @song.paused?)
			@track_playing = (@track_playing + 1) % @albums[@album_playing].tracks.length()
			playTrack(@track_playing, @albums[@album_playing])
		end
	end

	# Draws the album images and the track list for the selected album
	def draw
		draw_background()
		draw_albums_area()
		draw_albums(@albums)
		# If an album is selected => display its tracks
		if @album_playing >= 0
			draw_tracks(@albums[@album_playing])
			draw_current_track_playing(@track_playing, @albums[@album_playing])
		end
	end

 	def needs_cursor?; true; end


	def button_down(id)
		case id
	    when Gosu::MsLeft

	    	# If an album has been selected
	    	if @album_playing >= 0
		    	# --- Check which track was clicked on ---
		    	for index in 0...@albums[@album_playing].tracks.length()
			    	if area_clicked(@albums[@album_playing].tracks[index].dimension.leftX, 
									@albums[@album_playing].tracks[index].dimension.topY, 
									@albums[@album_playing].tracks[index].dimension.rightX, 
									@albums[@album_playing].tracks[index].dimension.bottomY)
			    		playTrack(index, @albums[@album_playing])
			    		@track_playing = index
			    		break
			    	end
			    end
			end

			# --- Check which album was clicked on ---
			for index in 0...@albums.length()
				if area_clicked(@albums[index].artwork.dimension.leftX, 
								@albums[index].artwork.dimension.topY, 
								@albums[index].artwork.dimension.rightX, 
								@albums[index].artwork.dimension.bottomY)
					@album_playing = index
					@song = nil
					break
				end
			end
		when Gosu::KB_A
			@song.pause
		when Gosu::KB_S
			@song.play
	    end
	end

end

# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0