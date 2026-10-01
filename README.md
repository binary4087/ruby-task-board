# Ruby Task Board

A simple Kanban-style TUI for managing tasks in the terminal.

## Usage
Run the application using:
```bash
ruby main.rb
```

## Commands
- `add [column] [title] [description]`: Adds a task to a specific column (Todo, In Progress, Done).
- `move [from_column] [index] [to_column]`: Moves a task by its index from one column to another.
- `delete [column] [index]`: Removes a task from the specified column.
- `search [query]`: Searches for tasks containing the query in title or description.
- `clear`: Removes all tasks from all columns.
- `quit`: Exits the application.