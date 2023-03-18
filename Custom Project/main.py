from tkinter import ttk
import random
import tkinter as tk
import tkinter.messagebox as messagebox


# Global constant for GUI settings

CELL_PADDING = 10
BACKGROUND_COLOR = "#92877d"
EMPTY_CELL_COLOR = "#9e948a"

# Tuple for GUI settings

FONT = ("SF Pro Rounded", 24, "bold")
BUTTON_UP = ("w", "W", "Up")
BUTTON_LEFT = ("a", "A", "Left")
BUTTON_DOWN = ("s", "S", "Down")
BUTTON_RIGHT = ("d", "D", "Right")

# Dictionary for GUI colors

CELL_BACKGROUND_COLOR = {
    "2": "#eee4da",
    "4": "#ede0c8",
    "8": "#f2b179",
    "16": "#f59563",
    "32": "#f67c5f",
    "64": "#f65e3b",
    "128": "#edcf72",
    "256": "#edcc61",
    "512": "#edc850",
    "1024": "#edc53f",
    "2048": "#edc22e",
    "beyond": "#3c3a32"
}

CELL_COLOR = {
    "2": "#776e65",
    "4": "#776e65",
    "8": "#f9f6f2",
    "16": "#f9f6f2",
    "32": "#f9f6f2",
    "64": "#f9f6f2",
    "128": "#f9f6f2",
    "256": "#f9f6f2",
    "512": "#f9f6f2",
    "1024": "#f9f6f2",
    "2048": "#f9f6f2",
    "beyond": "#f9f6f2"
}

#----------------------------------------------------------------#
# Creates a grid class which is a size * size integer matrix that contains the cell's true integer values
# As well as matrix manipulate functions which we can recall again in the Game class
# Represents data structure of the game

class Grid: 
    def __init__(self, n): 
        self.size = n
        self.cells = self.generate_empty_grid()
        self.compressed = False
        self.merged = False
        self.moved = False
        self.current_score = 0

    #----------------------------------------------------------------#
    # Generates a random cell after each move

    def generate_random_cell(self): 
        cell = random.choice(self.get_empty_cells())
        i = cell[0]
        j = cell[1]
        if random.random() < 0.9: 
            self.cells[i][j] = 2 
        else:
            self.cells[i][j] = 4

    #----------------------------------------------------------------#
    # Creates a list which contains all zeros in the nested for loop for each row in the matrix.
    # Then sends all zeros to the end of the list by append() function
    
    def get_empty_cells(self):
        empty_cells = [] 
        for i in range(self.size):
            for j in range(self.size):
                if self.cells[i][j] == 0:
                    empty_cells.append((i, j))
        return empty_cells

    #----------------------------------------------------------------#
    # Generates an empty size * size matrixx
    # Empty cell equals to 0

    def generate_empty_grid(self): 
        
        # [0] * self.size creates a list with int(self.size) [0] elements
        # Eg. If self.size == 4 then the list will be [0]
        # Which is equals to a row in the matrix
        # Then we use a nested loop to implement multidimensional sequences
        # Which results in a two dimensional list

        return [[0] * self.size for i in range(self.size)]

    #----------------------------------------------------------------#
    # Uses zip fucntion along with the unpacking operator and takes transpose of the matrix 
    # Flips the matrix over its diagonal (interchanging rows and column)

    def transpose(self):
        self.cells = [list(t) for t in zip(*self.cells)]

    #----------------------------------------------------------------#
    # Reverses the matrix horizontally

    def reverse(self): 
        for i in range(self.size):
            begin = 0
            end = self.size - 1
            while begin < end:
                self.cells[i][begin], self.cells[i][end] = self.cells[i][end], self.cells[i][begin]
                begin += 1
                end -= 1

    #----------------------------------------------------------------#
    # Clears every flag variable after each move

    def clear_flags_variable(self):
        self.compressed = False
        self.merged = False
        self.moved = False

    #----------------------------------------------------------------#
    # Compresses all non-zero numbers in the matrix to one side of the board
    # Fills in any empty spaces that might have existed between them
    # Returns flag variables

    def compress(self):
        self.compressed = False
        new_grid = self.generate_empty_grid() # Generates a new grid based on the current grid
        for i in range(self.size):
            count = 0
            for j in range(self.size):

                # If cell value is non-zero then we will shift it's number to the previous empty cell in that row

                if self.cells[i][j] != 0:
                    new_grid[i][count] = self.cells[i][j]
                    if count != j:
                        self.compressed = True
                    count += 1
        self.cells = new_grid

    #----------------------------------------------------------------#
    # Sums up any horizontally adjacent nonzero integers with the same value and merges them to the left position
    # Returns flag variable

    def merge(self):
        self.merged = False

        # We just loop until column size -1 so that we can use the j+1 index
        # Then, we will determine whether the value at [i][j] in the matrix is equal to [i][j+1] and is not zero

        for i in range(self.size):
            for j in range(self.size - 1):
                if self.cells[i][j] == self.cells[i][j + 1] and self.cells[i][j] != 0:

                    # Doubles current cell value and
                    # Empties the next cell
                    # Add score

                    self.cells[i][j] *= 2
                    self.cells[i][j + 1] = 0
                    self.current_score += self.cells[i][j]
                    self.merged = True

    #----------------------------------------------------------------#
    # Searches for 2048 in the matrix

    def has_2048(self):

        # Nested loop through the matrix which searches for 2048 value in the matrix
        # Returns flag variable

        for i in range(self.size):
            for j in range(self.size):
                if self.cells[i][j] >= 2048:
                    return True
        return False

    #----------------------------------------------------------------#
    # Checks if there is empty cell in the matrix

    def has_empty_cells(self): 

        # Nested loop thorugh the matrix which indentifies whether if there is empty cell in the matrix
        # Empty cell value equals to 0
        # Returns flag variable

        for i in range(self.size):
            for j in range(self.size):
                if self.cells[i][j] == 0:
                    return True
        return False

    #----------------------------------------------------------------#
    # Check if there is mergeable in the matrix

    def can_merge(self):

        # Sums up all the nonzero numbers in the 2048 game matrix 
        # That are horizontally contiguous and have the same value before merging them to the left position
        # Returns flag variable

        # In order to index with j + 1, we are just looping until column size - 1
        # Then, we will determine whether the value at position [i][j] in the matrix is not zero and equal to position [i][j+1]

        for i in range(self.size):
            for j in range(self.size - 1):
                if self.cells[i][j] == self.cells[i][j + 1]:
                    return True

        # Vice versa, indexs with i + 1 and compare [i][j] to [i+1][j]

        for j in range(self.size):
            for i in range(self.size - 1):
                if self.cells[i][j] == self.cells[i + 1][j]:
                    return True
        return False

    #----------------------------------------------------------------#
    # Prints the matrix into the terminal

    def print_grid(self):
        print("-" * 30)

        # We use the same logic as generate_empty_grid() functions

        for i in range(self.size): # Returns every single row
            for j in range(self.size): # Print cell's value in the row every single column
                print("%d\t" % self.cells[i][j], end="") 
            print("")
        print("-" * 30)

#----------------------------------------------------------------#
# Create a tkinter label widget which is a size * size grid that shows the integer value of the cell on the tkinter window

class GUI:

    #----------------------------------------------------------------#
    # Constructor on self
    # Initialize the object's attributes

    def __init__(self, grid): 
        self.grid = grid
        self.root = tk.Tk()
        self.root.title("2048") # Title of the tkinter window
        self.root.resizable(False, False) # Forbids resizing tk window horizontally and vertically
        self.background = tk.Frame(self.root, bg = BACKGROUND_COLOR) # Frame constructor to construct the game as a frame widget

        # Create tkinter GUI empty cell grid 

        self.cell_labels = []

        for i in range(self.grid.size):
            row_labels = []
            for j in range(self.grid.size):
                label = tk.Label(self.background, 
                                text = "",
                                bg = EMPTY_CELL_COLOR,
                                justify = tk.CENTER, 
                                font = FONT,
                                width = 8, 
                                height = 4)
                label.grid(row = i, 
                            column = j, 
                            padx = 20, 
                            pady = 20)
                row_labels.append(label)
            self.cell_labels.append(row_labels)
        self.background.grid()

    # Draw non-zero tkinter GUI cells

    def draw(self):
        for i in range(self.grid.size):
            for j in range(self.grid.size):
                if self.grid.cells[i][j] == 0:
                    self.cell_labels[i][j].configure(
                        text = "",
                        bg = EMPTY_CELL_COLOR)
                else:
                    cell_text = str(self.grid.cells[i][j])
                    if self.grid.cells[i][j] > 2048:
                        bg_color = CELL_BACKGROUND_COLOR.get("beyond")
                        fg_color = CELL_COLOR.get("beyond")
                    else:
                        bg_color = CELL_BACKGROUND_COLOR.get(cell_text)
                        fg_color = CELL_COLOR.get(cell_text)
                    self.cell_labels[i][j].configure(
                        text = cell_text,
                        bg = bg_color, 
                        fg = fg_color)

#----------------------------------------------------------------#
# Main game class which manages GUI and Grid class
class Game:

    #----------------------------------------------------------------#
    # Constructor on self
    # Initialize the object's attributes

    def __init__(self, grid, gui):
        self.grid = grid
        self.gui = gui
        self.start_cells_num = 2
        self.over = False
        self.won = False
        self.keep_playing = False

    #----------------------------------------------------------------#
    # Start the game

    def start(self):
        self.add_start_cells()
        self.gui.draw()
        self.gui.root.bind("<Key>", self.link_key)
        self.gui.root.mainloop()

    #----------------------------------------------------------------#
    # Calls generate_random_cell twice to star the game with 2 non-zero random cells

    def add_start_cells(self):
        for i in range(self.start_cells_num):
            self.grid.generate_random_cell()

    #----------------------------------------------------------------#
    # Check if there is any possible move
    # Either the matrix has empty cell or mergable cells or both

    def moveable(self):
        return self.grid.has_empty_cells() or self.grid.can_merge()


    #----------------------------------------------------------------#
    # Checks game status after everyn single operation as well as keyboard input handling
    
    def link_key(self, event):

        # Checks if the game is already won or lost
        # If lost, the function returns nothing
        # If won and the player chooses not to keep playing, the function returns nothing
        # If won and the player chooses to keep playing, the function continues the execution of the game

        if self.over or (self.won and (not self.keep_playing)):
            return

        self.grid.clear_flags_variable() # Clears flags variable after each move

        key_value = event.keysym # Bind key event to the callback
        print("{} key pressed".format(key_value))
        if key_value in BUTTON_UP:
            self.up()
        elif key_value in BUTTON_LEFT:
            self.left()
        elif key_value in BUTTON_DOWN:
            self.down()
        elif key_value in BUTTON_RIGHT:
            self.right()
        else:
            pass

        self.gui.draw() # Start GUI drawing after each move
        print("Score:", str(self.grid.current_score)) # Print score

        # Checks if there is 2048 in the matrix after each move
        # If there is 2048 in the matrix after each move, modifies game state to win
        # If there is no 2048 in the matrix, the fucntion returns nothing

        if self.grid.has_2048():
            self.game_win()
            if not self.keep_playing:
                return

        if self.grid.moved: # Generates a random cell if any element in the matrix moved
            self.grid.generate_random_cell()

        self.gui.draw() # Draw the GUI again in case a new element was created

        # Checks if there is any possible move after each move
        # If there is no possible move left, modifies the game state and call game_over() fucntion

        if not self.moveable(): 
            self.over = True
            self.game_over()

    # Print game won window
    def game_win(self):
        if not self.won:
            self.won = True
            print("You Win!")
            if messagebox.askyesno("2048", "You Win!\n"
                                    "Are you going to keep playing?"):
                self.keep_playing = True
    
    # Print game over window
    def game_over(self):
        print("Game over!")
        messagebox.showinfo("2048", "Whoopsie!\n"
                                    "Game over!")

    def up(self):
        self.grid.transpose()
        self.grid.compress()
        self.grid.merge()
        self.grid.moved = self.grid.compressed or self.grid.merged
        self.grid.compress()
        self.grid.transpose()
        self.grid.print_grid()

    def left(self):
        self.grid.compress()
        self.grid.merge()
        self.grid.moved = self.grid.compressed or self.grid.merged
        self.grid.compress()
        self.grid.print_grid()

    def down(self):
        self.grid.transpose()
        self.grid.reverse()
        self.grid.compress()
        self.grid.merge()
        self.grid.moved = self.grid.compressed or self.grid.merged
        self.grid.compress()
        self.grid.reverse()
        self.grid.transpose()
        self.grid.print_grid()

    def right(self):
        self.grid.reverse()
        self.grid.compress()
        self.grid.merge()
        self.grid.moved = self.grid.compressed or self.grid.merged
        self.grid.compress()
        self.grid.reverse()
        self.grid.print_grid()

def main():
    size = 4
    grid = Grid(size)
    gui = GUI(grid)
    game2048 = Game(grid, gui)
    game2048.start()

main()