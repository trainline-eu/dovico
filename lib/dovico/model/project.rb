require 'active_attr'

module Dovico
  class Project < Assignment

    attribute :tasks

    def self.all
      projects_search = ApiClient.get(URL_PATH)
      projects = projects_search["Assignments"].map {|project_hash| parse(project_hash) }

      projects.each do |project|
        tasks_search = ApiClient.get("#{URL_PATH}#{project.assignement_id}")
        project.tasks = tasks_search["Assignments"].map {|task_hash| Task.parse(task_hash) }
      end
    end
  end
end
