require 'active_attr'

module Dovico
  class Project < Assignment

    attribute :tasks

    def self.parse(hash)
      project = super(hash)
      project.tasks ||= []
      project
    end

    def self.all
      projects_search = ApiClient.get(URL_PATH)
      projects = projects_search["Assignments"].map {|project_hash| parse(project_hash) }

      projects.each do |project|
        tasks_search = ApiClient.get("#{URL_PATH}#{project.assignement_id}")
        project.tasks = tasks_search["Assignments"].map {|task_hash| Task.parse(task_hash) }
      end

      projects
    end

    def self.format_all
      text = " Project | Task | Description"
      text += all.map(&:to_s).join("\n")
    end

    def to_s
      text = ''

      if tasks.count > 0
        tasks.each do |task|
          text += sprintf ' %7d | %4d | %s: %s', id, task.id, name, task.name
        end
      else
        text += sprintf " %7d |      | %s (No tasks linked)", id, name
      end

      text
    end
  end
end
