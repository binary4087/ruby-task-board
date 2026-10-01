require 'json'
require_relative 'board/task'
require_relative 'board/column'

class TaskBoard
  attr_reader :columns
  STORAGE_FILE = 'board_data.json'

  # ANSI Color Codes
  COLORS = {
    reset: "\e[0m",
    bold: "\e[1m",
    blue: "\e[34m",
    green: "\e[32m",
    yellow: "\e[33m",
    cyan: "\e[36m",
    red: "\e[31m"
  }

  def initialize
    @columns = {
      "Todo" => Board::Column.new("Todo"),
      "In Progress" => Board::Column.new("In Progress"),
      "Done" => Board::Column.new("Done")
    }
    load_data
  end

  def add_task(column_name, title, description, priority = "Normal")
    if @columns[column_name]
      task = Board::Task.new(title, description, priority)
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

  def clear_board
    @columns.each_value { |col| col.tasks.clear }
    save_data
    true
  end

  def search_tasks(query)
    results = []
    @columns.each do |col_name, col|
      col.tasks.each_with_index do |task, idx|
        if task.title.downcase.include?(query.downcase) || task.description.downcase.include?(query.downcase)
          results << "[#{col_name}] Index #{idx}: #{task}"
        end
      end
    end
    results
  end

  def list_column(column_name)
    col = @columns[column_name]
    return nil unless col

    puts "\n#{COLORS[:bold]}#{COLORS[:cyan]}--- #{column_name.upcase} ---#{COLORS[:reset]}"
    if col.tasks.empty?
      puts "  (Empty)"
    else
      col.tasks.each_with_index do |task, i|
        task_color = task.priority == "High" ? COLORS[:red] : ""
        puts "  #{COLORS[:bold]}#{i}:#{COLORS[:reset]} #{task_color}#{task}#{COLORS[:reset]}"
      end
    end
    puts "#{COLORS[:cyan]}-------------------#{COLORS[:reset]}"
    true
  end

  def display
    puts "\n#{COLORS[:bold]}#{COLORS[:cyan]}--- KANBAN BOARD ---#{COLORS[:reset]}"
    
    col_colors = {
      "Todo" => COLORS[:yellow],
      "In Progress" => COLORS[:blue],
      "Done" => COLORS[:green]
    }

    @columns.each do |name, col|
      color = col_colors[name] || COLORS[:reset]
      puts "\n#{color}#{COLORS[:bold]}#{name.upcase}#{COLORS[:reset]}"
      puts "#{color}" + "-" * name.length + "#{COLORS[:reset]}"
      
      if col.tasks.empty?
        puts "  (Empty)"
      else
        col.tasks.each_with_index do |task, i|
          task_color = task.priority == "High" ? COLORS[:red] : ""
          puts "  #{COLORS[:bold]}#{i}:#{COLORS[:reset]} #{task_color}#{task}#{COLORS[:reset]}"
        end
      end
    end
    puts "\n#{COLORS[:cyan]}-------------------#{COLORS[:reset]}"
  end

  private

  def save_data
    data = {}
    @columns.each do |name, col|
      data[name] = col.tasks.map { |t| { title: t.title, description: t.description, priority: t.priority } }
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
            @columns[col_name].add_task(Board::Task.new(t_data['title'], t_data['description'], t_data['priority'] || "Normal"))
          end
        end
      end
    rescue JSON::ParserError
      puts "Error loading saved data. Starting with a fresh board."
    end
  end
end