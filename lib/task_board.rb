require 'json'
require_relative 'board/task'
require_relative 'board/column'

class TaskBoard
  attr_reader :columns
  STORAGE_FILE = 'board_data.json'

  def initialize
    @columns = {
      "Todo" => Board::Column.new("Todo"),
      "In Progress" => Board::Column.new("In Progress"),
      "Done" => Board::Column.new("Done")
    }
    load_data
  end

  def add_task(column_name, title, description)
    if @columns[column_name]
      task = Board::Task.new(title, description)
      @columns[column_name].add_task(task)
      save_data
      true
    else
      false
    end
  end

  def move_task(from_col, from_idx, to_col)
    return false unless @columns[from_col] && @columns[to_col]
    task = @columns[from_col].remove_task(from_idx)
    if task
      @columns[to_col].add_task(task)
      save_data
    end
    !!task
  end

  def delete_task(column_name, index)
    if @columns[column_name]
      task = @columns[column_name].remove_task(index)
      if task
        save_data
        return true
      end
    end
    false
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

  private

  def save_data
    data = {}
    @columns.each do |name, col|
      data[name] = col.tasks.map { |t| { title: t.title, description: t.description } }
    end
    File.write(STORAGE_FILE, JSON.pretty_generate(data))
  end

  def load_data
    return unless File.exist?(STORAGE_FILE)

    begin
      data = JSON.parse(File.read(STORAGE_FILE))
      data.each do |col_name, tasks|
        if @columns[col_name]
          tasks.each do |t_data|
            @columns[col_name].add_task(Board::Task.new(t_data['title'], t_data['description']))
          end
        end
      end
    rescue JSON::ParserError
      puts "Error loading saved data. Starting with a fresh board."
    end
  end
end