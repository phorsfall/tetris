module Tetris
  class PlayField
    attr_reader :cells

    Rows, Columns = 22, 10
    CellSize = 28
    LineClearDelay = 20
    
    def initialize(window, scoring)
      @window = window
      @scoring = scoring
      initialize_cells
      @clearing_lines = false
      @line_clear_counter = 0
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

    def complete_rows
      lines = []
      @cells.each_with_index do |row, index|
        lines << index if row.uniq == [1]
      end
      lines
    end

    def clear_complete_rows
      complete_rows.each do |index|
        delete_row(index)
        insert_row
      end.length
    end

    def clearing_lines?
      @clearing_lines
    end

    def update
      @clearing_lines ||= !complete_rows.empty?

      if clearing_lines?
        @window.play_sample(:fx1) if @line_clear_counter.zero?
        if @line_clear_counter < LineClearDelay
          @line_clear_counter += 1
        else
          rows_cleared = clear_complete_rows
          @scoring.line_clear(rows_cleared)
          @line_clear_counter = 0
          @clearing_lines = false
          @window.play_sample :explosion2
        end
      end
    end

    def draw
      each_cell do |row, col, state|
        next if row < 2
        x, y = col * CellSize, row * CellSize
        # TODO: Clean up the selection of block colour.
        if complete_rows.include?(row)
          # TODO: Pull out constant for speed of flashing. (The 6 below.)
          c = (@line_clear_counter/6) % 2 == 0 ? Gosu::Color::WHITE : Gosu::Color::GRAY
        else
          c = state ? Gosu::Color::WHITE : Gosu::Color::GRAY
        end
        size = CellSize - 1
        @window.draw_square x, y, c, size
      end
    end
  end
end
