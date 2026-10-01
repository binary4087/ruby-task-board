require_relative 'lib/task_board'

board = TaskBoard.new

loop do
  board.display
  puts "\nCommands: add [col] [title] [desc] | move [from] [idx] [to] | delete [col] [idx] | search [query] | clear | quit"
  print "> "
  input = gets.chomp.split(' ')

  case input[0]
  when 'add'
    col, title, *desc = input[1..-1]
    if board.add_task(col, title, desc.join(' '))
      puts "Task added!"
    else
      puts "Invalid column."
    end
  when 'move'
    from, idx, to = input[1..-1]
    if board.move_task(from, idx.to_i, to)
      puts "Task moved!"
    else
      puts "Move failed. Check column names and index."
    end
  when 'delete'
    col, idx = input[1..-1]
    if board.delete_task(col, idx.to_i)
      puts "Task deleted!"
    else
      puts "Delete failed. Check column names and index."
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