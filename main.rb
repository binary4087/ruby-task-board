require_relative 'lib/task_board'

board = TaskBoard.new

loop do
  board.display
  puts "\nCommands: add [col] [title] [desc] | move [from] [idx] [to] | delete [col] [idx] | search [query] | clear | quit"
  print "> "
  input_str = gets.chomp
  input = input_str.split(' ')

  case input[0]
  when 'add'
    col, title, *desc = input[1..-1]
    if col && title
      if board.add_task(col, title, desc.join(' '))
        puts "Task added!"
      else
        puts "Invalid column. Available: Todo, In Progress, Done"
      end
    else
      puts "Usage: add [column] [title] [description]"
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