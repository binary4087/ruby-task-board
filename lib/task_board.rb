require_relative 'board/task'
require_relative 'board/column'

class TaskBoard
  attr_reader :columns

  def initialize
    @columns = {
      "Todo" => Board::Column.new("Todo"),
      "In Progress" => Board::Column.new("In Progress"),
      "Done" => Board::Column.new("Done")
    }
  end

  def add_task(column_name, title, description)
    if @columns[column_name]
      task = Board::Task.new(title, description)
      @columns[column_name].add_task(task)
      true
    else
      false
    end
  end

  def move_task(from_col, from_idx, to_col)
    return false unless @columns[from_col] && @columns[to_col]
    task = @columns[from_col].remove_task(from_idx)
    @columns[to_col].add_task(task) if task
    !!task
  end

  def display
    puts "\n--- KANBAN BOARD ---"
    @columns.each do |name, col|
      puts "\n#{name.upcase}"
      puts "-" * name.length
      if col.tasks.empty?
        puts "  (Empty)"
      else
        col.tasks.each_with_index do |task, i|
          puts "  #{i}: #{task}"
        end
      end
    end
    puts "\n-------------------"
  end
end