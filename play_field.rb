module Tetris
  class PlayField
    attr_reader :cells
    
    Rows, Columns = 20, 10
    CellSize = 32
    
    def initialize(window)
      @window = window
      initialize_cells
    end
    
    def initialize_cells
      @cells = []      
      Rows.times { insert_row }
    end
    
    def each_cell
      Columns.times do |col|
        Rows.times do |row|
          yield row, col, @cells[row][col]
        end
      end
    end
    
    def insert_row
      @cells.insert 0, [nil] * Columns
    end
    
    def delete_row(index)
      @cells.delete_at(index)
    end
    
    def clear_lines
      count = 0
      @cells.each_with_index do |row, index|
        if row.uniq == [1]
          delete_row(index)
          insert_row
          count += 1
        end
      end
      count
    end
    
    def draw
      each_cell do |row, col, state|
        x, y = col * CellSize, row * CellSize
        c = state ? Gosu::Color::WHITE : Gosu::Color::GRAY
        size = CellSize - 1
        @window.draw_square x, y, c, size
      end
    end
  end
end