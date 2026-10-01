module Board
  class Task
    attr_accessor :title, :description, :priority

    def initialize(title, description = "", priority = "Normal")
      @title = title
      @description = description
      @priority = priority
    end

    def to_s
      priority_tag = @priority == "High" ? "[HIGH] " : ""
      "#{priority_tag}[#{@title}] - #{@description}"
    end
  end
end