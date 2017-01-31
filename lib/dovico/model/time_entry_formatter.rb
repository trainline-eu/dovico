module Dovico
  class TimeEntryFormatter

    def initialize(projects)
      @projects = projects
    end

    def format_entries(time_entries)
      text = ""
      time_entries.map do |time_entry|
        text += "#{}"
        time_entry_text(time_entry)
      end.join("\n")
    end

    private
    attr_accessor :projects

    def time_entry_text(time_entry)
      project, task = project_task(time_entry.project_id, time_entry.task_id)

      progress_bar_width = (time_entry.total_hours.to_f * 2).to_i
      sprintf("%s [%s] %s : [%8s] %2sh %s %s",
        time_entry.date,
        "×" * progress_bar_width,
        " " * [16 - progress_bar_width, 0].max,
        time_entry.formal_sheet_status,
        time_entry.total_hours,
        project.name,
        task.name,
      )
    end

    def project_task(project_id, task_id)
      project = projects.select{ |project| project.id == project_id }.first
      task = project.tasks.select{ |task| task.id == task_id }.first

      [project, task]
    end
  end
end
