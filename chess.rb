#white and gray squares
#unicode piece representations
#method of entry:
#enter piece, show potential squares in green?
#enter piece and move at same time in shorthand?
#tricky stuff: en passant, pawn promotion
class Piece
  attr_accessor :color, :row, :col
  def initialize(color, row, col)
    @color = color
    @row = row
    @col = col
    @unicode_suffixes = ['', '']
  end

  #gives the unicode symbol for the piece of this color
  def symbol
    "265" + @color == :white ? @unicode_suffixes[0] : @unicode_suffixes[1]
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
    @unicode_suffixes = ['9', 'F']
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
    @unicode_suffixes = ['6', 'C']
  end

  def move_deltas
  end
end

class Bishop < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @unicode_suffixes = ['7', 'D']
  end

  def move_deltas
  end
end

class Knight < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @unicode_suffixes = ['8', 'E']
  end

  def move_deltas
  end
end

class Queen < Piece
  def initialize(color, row, col)
    super(color, row, col)
    @unicode_suffixes = ['5', 'B']
  end

  def move_deltas
  end
end

class King < Piece
  #add check stuff
  def initialize(color, row, col)
    super(color, row, col)
    @unicode_suffixes = ['4', 'A']
  end

  def move_deltas
  end
end

class Board
  attr_accessor :grid
  def initialize
  end
end
