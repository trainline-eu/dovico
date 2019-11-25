module Dovico
  class TimeEntryFormatter

    def initialize(assignments)
      @assignments = assignments
    end

    def format_entries(time_entries)
      time_entries.group_by(&:date).map do |date, day_time_entries|
        hours = 0

        day_time_entries.map do |time_entry|
          string = "#{date} #{progress_bar(hours, time_entry.total_hours)} #{time_entry_text(time_entry)}"
          hours += time_entry.total_hours.to_f

          string
        end
      end.flatten.join("\n")
    end

    private
    attr_accessor :assignments

    def progress_bar(shift, total_hours)
      progress_bar_width = (total_hours.to_f * 2).to_i
      sprintf(
        "[%- 14s]", " " * shift * 2 + "×" * progress_bar_width
      )
    end

    def time_entry_text(time_entry)
      project, task = assignments.find_project_task(time_entry.project_id, time_entry.task_id)

      sprintf("[%-12s] %2sh %s %s",
        time_entry.formal_sheet_status,
        time_entry.total_hours,
        project.name,
        task.name,
      )
    end
  end
end
