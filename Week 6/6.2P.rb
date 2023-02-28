
# Task 6.1 T - use the code from last week's tasks to complete this:
# eg: 5.1T, 5.2T

module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
  end
  
  $genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
  
  class Album
  # NB: you will need to add tracks to the following and the initialize()
      attr_accessor :title, :artist, :genre ,:tracks
  
  # complete the missing code:
      def initialize (title, artist, genre, tracks)
          @title = title
          @artist = artist
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
      t = Track.new(name, location)
      return t
  end
  
  # Returns an array of tracks read from the given file
  
  def read_tracks(music_file)
      
      index = music_file.gets().to_i
        tracks = Array.new()
      while index > 0
            track = read_track(music_file)
            tracks << track
          index -= 1
      end
      return tracks
  end
  
  # Takes an array of tracks and prints them to the terminal
  
  def print_tracks(tracks)
      index = 0
      while index < tracks.length()
          puts(tracks[index].name)
          puts(tracks[index].location)
          index += 1
      end
  end
  
  # Reads in and returns a single album from the given file, with all its tracks
  
  def read_album(music_file)
  
      album_artist = music_file.gets.chomp.to_s
      album_title = music_file.gets.chomp.to_s
      album_genre = music_file.gets.chomp.to_i
      tracks = read_tracks(music_file)
  
      album = Album.new(album_title, album_artist, album_genre, tracks)
      return album
  end
  
  
  # Takes a single album and prints it to the terminal along with all its tracks
  def print_album(album)
  
      puts(album.artist)
      puts(album.title)
      puts('Genre is ' + album.genre.to_s)
      puts($genre_names[album.genre])
      # print out the tracks
      print_tracks(album.tracks)
  end
  
  # Takes a single track and prints it to the terminal
  def print_track(track)
        puts('Track title is: ' + track.title)
      puts('Track file location is: ' + track.file_location)
  end
  
  # Reads in an album from a file and then print the album to the terminal
  
  def main()
      music_file = File.new("album.txt", "r")
      album = read_album(music_file)
      music_file.close()
      print_album(album)
  end
  
  main()