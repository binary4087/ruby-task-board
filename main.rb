require_relative 'lib/task_board'

board = TaskBoard.new

loop do
  board.display
  puts "\nCommands: add [col] [title] [desc] | move [from] [idx] [to] | quit"
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
  when 'quit'
    break
  else
    puts "Unknown command."
  end
end