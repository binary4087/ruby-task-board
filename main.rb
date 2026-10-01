require_relative 'lib/task_board'

board = TaskBoard.new

loop do
  board.display
  puts "\nCommands: add [col] \"title\" \"desc\" [priority] | move [from] [idx] [to] | delete [col] [idx] | list [col] | search \"[query]\" | clear | quit"
  puts "Columns: Todo, In Progress, Done"
  puts "Priority: High, Normal (default)"
  print "> "
  input_str = gets.chomp
  
  # Improved parsing using a regex to handle quoted strings
  input = input_str.scan(/"([^"]*)"|(\S+)/).map { |m| m[0] || m[1] }
  next if input.empty?

  case input[0]
  when 'add'
    col, title, desc, priority = input[1..-1]
    if col && title
      # Handle optional priority if provided as 4th argument
      # If priority is not 'High' or 'Normal', treat it as part of description
      actual_priority = "Normal"
      actual_desc = desc || ""

      if priority && ["High", "Normal"].include?(priority)
        actual_priority = priority
      elsif priority
        actual_desc = [desc, priority].compact.join(' ')
      end

      if board.add_task(col, title, actual_desc, actual_priority)
        puts "Task added!"
      else
        puts "Invalid column. Available: Todo, In Progress, Done"
      end
    else
      puts "Usage: add [column] \"title\" \"description\" [priority]"
    end
  when 'move'
    from, idx_str, to = input[1..-1]
    if from && idx_str && to && idx_str.match?(/^\d+$/)
      if board.move_task(from, idx_str.to_i, to)
        puts "Task moved!"
      else
        puts "Move failed. Check column names and index."
      end
    else
      puts "Usage: move [from_column] [index] [to_column]"
    end
  when 'delete'
    col, idx_str = input[1..-1]
    if col && idx_str && idx_str.match?(/^\d+$/)
      if board.delete_task(col, idx_str.to_i)
        puts "Task deleted!"
      else
        puts "Delete failed. Check column names and index."
      end
    else
      puts "Usage: delete [column] [index]"
    end
  when 'list'
    col = input[1]
    if col
      unless board.list_column(col)
        puts "Invalid column. Available: Todo, In Progress, Done"
      end
    else
      puts "Usage: list [column]"
    end
  when 'search'
    query = input[1..-1].join(' ')
    if query.empty?
      puts "Please provide a search query."
    else
      results = board.search_tasks(query)
      if results.any?
        puts "Search results:"
        results.each { |r| puts "  #{r}" }
      else
        puts "No tasks found matching '#{query}'."
      end
    end
  when 'clear'
    board.clear_board
    puts "Board cleared!"
  when 'quit'
    break
  else
    puts "Unknown command."
  end
end