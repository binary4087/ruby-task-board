require_relative 'lib/task_board'

board = TaskBoard.new

loop do
  board.display
  puts "\nCommands: add [col] [title] [desc] [priority] | move [from] [idx] [to] | delete [col] [idx] | search [query] | clear | quit"
  puts "Priority: High, Normal (default)"
  print "> "
  input_str = gets.chomp
  input = input_str.split(' ')

  case input[0]
  when 'add'
    col, title, *desc_and_pri = input[1..-1]
    if col && title
      # The last word might be the priority if it is 'High' or 'Normal'
      priority = "Normal"
      description_parts = desc_and_pri
      if desc_and_pri && !desc_and_pri.empty?
        last_word = desc_and_pri.last
        if ["High", "Normal"].include?(last_word)
          priority = last_word
          description_parts = desc_and_pri[0...-1]
        end
      end

      if board.add_task(col, title, description_parts.join(' '), priority)
        puts "Task added!"
      else
        puts "Invalid column. Available: Todo, In Progress, Done"
      end
    else
      puts "Usage: add [column] [title] [description] [priority]"
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