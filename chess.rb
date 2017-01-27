#white and gray squares
#unicode piece representations
#method of entry:
#enter piece, show potential squares in green?
#enter piece and move at same time in shorthand?
#tricky stuff: en passant, pawn promotion, castle
require 'colorize'

class Piece
  attr_accessor :color, :row, :col
  def initialize(color, row, col)
    @color = color
    @row = row
    @col = col
    @unicode_suffixes = ['', '']
    @letter = " "
  end

  #gives the letter symbol for the piece of this color
  def symbol
    @color == :white ? @letter.light_white : @letter
  end

  #gives all possible row/col changes that are legal moves if not off the board
  def move_deltas
    []
  end

  #checks if a coordinate pair is a legal place to move
  def is_legal_move(row, col)
    [row, col].each do |n|
      return false if n > 7 || n < 0
    end
    #can be made more efficient: deltas from @r/r, @c/c in deltas?
    move_deltas.each do |deltas|
      row_d = deltas[0]
      col_d = deltas[1]
      return true if @row+row_d == row && @col+col_d == col
    end
    false
  end

  #returns true and moves a piece if it's legal, returns false if illegal
  def move(row, col)
    return false if !is_legal_move(row, col)
    @row = row
    @col = col
  end
end

class Pawn < Piece
  attr_accessor :has_moved
  def initialize(color, row, col)
    super(color, row, col)
    @has_moved = false
    @letter = "P"
  end

  def move_deltas
    #TODO add en passant
    deltas = [[1, 0]]
    deltas << [2, 0] if !@has_moved
    deltas.map! {|d| d.map {|i| i*-1}} if @color == :white#pawns only move one direction
    deltas
  end

  def move(row, col)
    if super(row, col)
      @has_moved = true
      return true
    else
      return false
    end
  end
end

class Rook < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @letter = "R"
  end

  def move_deltas
  end
end

class Bishop < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @letter = "B"
  end

  def move_deltas
  end
end

class Knight < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @letter = "N"
  end

  def move_deltas
  end
end

class Queen < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @letter = "Q"
  end

  def move_deltas
  end
end

class King < Piece
  #add check stuff
  def initialize(color, row, col)
    super(color, row, col)
    @letter = "K"
  end

  def move_deltas
  end
end

class Cell
  attr_accessor :piece
  def initialize(piece=nil)
    @piece = piece
  end

  def print_format
    return " ".on_white if @piece == nil
    @piece.symbol.on_white
  end

end

class Board
  attr_accessor :grid
  def initialize
    #place pieces here
    @grid = 8.times.map {8.times.map {Cell.new}}
    #place pawns
    8.times do |col|
      @grid[1][col].piece = Pawn.new(:black, 1, col)
      @grid[6][col].piece = Pawn.new(:white, 6, col)
    end
    #place rooks
    [0, 7].each do |col|
      @grid[0][col].piece = Rook.new(:black, 0, col)
      @grid[7][col].piece = Rook.new(:white, 7, col)
    end
    #place bishops
    [1, 6].each do |col|
      @grid[0][col].piece = Bishop.new(:black, 0, col)
      @grid[7][col].piece = Bishop.new(:white, 7, col)
    end
    #place knights
    [2, 5].each do |col|
      @grid[0][col].piece = Knight.new(:black, 0, col)
      @grid[7][col].piece = Knight.new(:white, 7, col)
    end
    #place queens
    @grid[0][3].piece = Queen.new(:black, 0, 3)
    @grid[7][3].piece = King.new(:white, 7, 3)
    #place kings
    @grid[0][4].piece = Queen.new(:black, 0, 4)
    @grid[7][4].piece = King.new(:white, 7, 4)
  end

  def print_board
    put_line
    @grid.each do |row|
      print "|".on_white
      row.each do |cell|
        print cell.print_format + "|".on_white
      end
      put_line
    end
    true
  end

  def put_line
    puts ""
    17.times {print "-".on_white}
    puts ""
  end
end
