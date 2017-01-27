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

  def legal_moves
    moves = move_deltas
    move_deltas.each do |delta_pair|
      delta_pair.each do |delta|
        moves.delete(delta_pair) if delta < 0 || delta > 7
      end
    end
    moves
  end

  #checks if a coordinate pair is a legal place to move
  def is_legal_move(row, col)
    legal_moves.include?([row, col])
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
  attr_accessor :piece, :selected
  def initialize(piece=nil)
    @piece = piece
    @selected = false
  end

  def print_format
    return " ".on_white if @piece == nil
    if !@selected
      return @piece.symbol.on_white
    else
      return @piece.symbol.on_light_green
    end
  end

end

class Board
  attr_accessor :grid

  def initialize
    placement = {0 => Rook,
                 1 => Bishop,
                 2 => Knight,
                 3 => Queen,
                 4 => King,
                 5 => Knight,
                 6 => Bishop,
                 7 => Rook}
    @grid = 8.times.map {8.times.map {Cell.new}}
    #place pawns
    8.times do |col|
      @grid[1][col].piece = Pawn.new(:black, 1, col)
      @grid[6][col].piece = Pawn.new(:white, 6, col)
    end
    #place other pieces
    8.times do |col|
      @grid[0][col].piece = placement[col].new(:black, 0, col)
      @grid[7][col].piece = placement[col].new(:white, 7, col)
    end
  end

  def select_cell cell
    @selected_cell.selected = false unless @selected_cell.nil?
    @selected_cell = cell
    @selected_cell.selected = true
  end

  def put_line
    puts ""
    17.times {print "-".on_white}
    puts ""
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


end
