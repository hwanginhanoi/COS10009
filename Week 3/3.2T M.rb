require './input_functions'

def maintain_albums()
  finished = false
  begin
  puts("Maintain Albums Menu:")
  puts("1 To Update Album Title")
  puts("2 To Update Album Genre")
  puts("3 To Enter Album")
  puts("4 Exit")
  choice=read_integer_in_range("Please enter your choice:", 1,4)
  case choice
  when 1
    print('You selected Update Album Title. ')
    read_string("Press enter to continue")
  when 2 
    print('You selected Update Album Genre. ')
    read_string("Press enter to continue")
  when 3
    print('You selected Enter Album. ')
    read_string("Press enter to continue")
  when 4
    finished = true
  end
  end until finished
end

def play_existing_album()
  puts("You selected Play Existing Album. Press enter to continue")
  gets()
end

def main()
  finished = false
  begin
    puts('Main Menu:')
    puts('1 To Enter or Update Album')
    puts('2 To Play Existing Album')
    puts('3 Exit')
    choice = read_integer_in_range("Please enter your choice:", 1,3)
    case choice
    when 1
      maintain_albums()
	  when 2
      play_existing_album()
    when 3
      finished = true
    else
      puts("Please select again")
    end
  end until finished
end

main()