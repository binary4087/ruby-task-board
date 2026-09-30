module Board
  class Task
    attr_accessor :title, :description

    def initialize(title, description = "")
      @title = title
      @description = description
    end

    def to_s
      "[#{@title}] - #{@description}"
    end
  end
end