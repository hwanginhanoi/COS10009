require './input_functions'

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :artist, :title, :year, :genre, :tracks

	def initialize (artist, title, year, genre, tracks)
		@title = title
		@artist = artist
		@year = year
		@genre = genre
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# Reads in and returns a single track from the given file

def read_track(music_file)
	name = music_file.gets()
	location = music_file.gets()
	track = Track.new(name, location)

	return track
end

# Returns an array of tracks read from the given file

def read_tracks(music_file)
	count = music_file.gets.chomp.to_i
  	tracks = Array.new

	while count > 0
		track = read_track(music_file)
  		tracks << track
		count -= 1
	end

	return tracks
end

# Reads in and returns a single album from the given file, with all its tracks

def read_album(music_file)
	artist = music_file.gets.chomp.to_s
	title = music_file.gets.chomp.to_s
	year = music_file.gets.chomp.to_s
	genre = music_file.gets.chomp.to_s
	tracks = read_tracks(music_file)

	album = Album.new(artist, title, year, genre, tracks)

	return album
end

# Read every albums

def read_albums()
	filename = read_string("\nEnter filename")
	music_file = File.new(filename, "r")
	count = music_file.gets.to_i

	albums = Array.new

	while count > 0
		album = read_album(music_file)
		albums << album
		count -= 1
	end

	music_file.close()

 	puts "\nThe albums have been loaded."
	puts "\n"
  
	return albums
end

# Display all albums

def display_all_albums(albums)
	for index in 0..albums.length() - 1
		puts("\nAlbum ID: " + (index + 1).to_s)
		display_album(albums[index])
		puts ("")
	end
end

# Display a single album

def display_album(album)
	puts("Artist: " + album.artist)
	puts("Title: " + album.title)
	puts("Year: " + album.year)
	puts('Genre is ' + album.genre.to_s)
	puts($genre_names[album.genre.to_i])
	# print out the tracks
	display_tracks(album.tracks)
end

# Display all tracks of an album

def display_tracks(tracks)
	index = tracks.length()
	puts("")
	puts "There are " + index.to_s + " tracks in the album:"
  
	for i in 0..index - 1
	  puts "Track " + (i+1).to_s + ":"
	  display_track(tracks[i])
	end
end
  
# Display a single track

def display_track(track)
	puts('Title: ' + track.name)
	puts('File location: ' + track.location)
	puts("")
end

# Display genre names

def display_genres(albums)
	puts "\nSelect genre"
	puts "1 - Pop"
	puts "2 - Classic"
	puts "3 - Jazz"
	puts "4 - Rock"

	genre = read_integer_in_range("\nPlease enter your choice: ", 1, 4)
	genre = genre.to_s

	display_albums_by_genre(genre, albums)
end

# Display all tracks of an album by genre

def display_albums_by_genre(genre, albums)
	for index in 0..albums.length - 1
		if albums[index].genre == genre
		  puts ("\nAlbum ID: " + (index + 1).to_s)
		  display_album(albums[index])
		  puts ""
		end
	end
end

# Display albums menu

def display_albums(albums)
	if albums == nil
		puts "\nNo album has been loaded"
		puts "\n"
		return 
	end
	
	puts "\nHow do you want to display:"
	puts "1. Display all albums"
	puts "2. Display genres"

	choice = read_integer_in_range("\nOption: ", 1, 5 )

	case choice
	when 1
		display_all_albums(albums)
	when 2
		display_genres(albums)
	else
		puts "\nPlease enter a value between 1 and 2"
	end
end

# Play album by ID

def play_album(albums)

	if albums == nil
        puts "\nNo album has been loaded"
		return
	end

	album_id = read_integer_in_range("\nEnter album's ID: ", 1, albums.length())
	track_count = albums[album_id - 1].tracks.length

	if track_count == 0
		puts("There are no track in the album")
		return
	end

	puts("\nThere are " + track_count.to_s + " tracks")

	for index in 0..track_count - 1
		puts ((index+1).to_s + ". " + albums[album_id - 1].tracks[index].name)
	end

	choice = read_integer_in_range("\nEnter track you want to play:", 1, track_count)

	puts("\n♬ ♫ ♪♩ Playing track " + albums[album_id - 1].tracks[choice-1].name.chomp + " from album " + albums[album_id - 1].title + " ♩ ♪ ♫ ♬") 

	read_string("\nPress enter to return to menu...")

end

# Update existing album information

def update_existing_album(albums)
	if albums == nil
        puts "\nNo album has been loaded"
		return
	end
	
	album_id = read_integer_in_range("\nAlbum ID: ", 1, albums.length())

	puts "\nWhat information do you want to update:"
	puts "1. Update title"
	puts "2. Update genre"
  
	choice = read_integer_in_range("\nPlease enter your choice:", 1, 2)
  
	case choice
		when 1
			string = read_string("\nNew title: ")
			albums[album_id - 1].title = string
		when 2
			string = read_string("\nNew genre: ")
			albums[album_id - 1].genre = string
	end
	puts "Updated album info:"
	puts "\nAlbum #{album_id}:"
	display_album(albums[album_id - 1])
end

# Display main menu

def main()
    finished = false
	albums = nil
	begin
		puts("\nMain Menu:")
   		puts("\n1. Read in Albums")
    	puts("2. Display Albums")
    	puts("3. Select an Album to play")
    	puts("4. Update an existing Album")
    	puts("5. Exit the application")
    	
		choice = read_integer_in_range("\nOption: ", 1, 5 )
		
		case choice
			when 1
				albums = read_albums()
			when 2
				display_albums(albums)
			when 3
				play_album(albums)
			when 4
				update_existing_album(albums)
			when 5
				finished = true
		end
	end until finished
end

main()
