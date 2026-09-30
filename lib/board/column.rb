module Board
  class Column
    attr_reader :name, :tasks

    def initialize(name)
      @name = name
      @tasks = []
    end

    def add_task(task)
      @tasks << task
    end

    def remove_task(index)
      @tasks.delete_at(index)
    end
  end
end