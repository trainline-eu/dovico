require 'active_attr'

module Dovico
  class TimeEntryGenerator
    DEFAULT_START_HOUR = 9

    def initialize(assignments:, employee_id:)
      @assignments = assignments
      @employee_id = employee_id
    end

    def generate(start_date, end_date)
      start_date.upto(end_date).flat_map do |day|
        build_day_time_entries(day)
      end
    end

    private
    attr_accessor :assignments, :employee_id

    def build_day_time_entries(day)
      time_entries = []
      start_date = Time.parse(day.to_s).advance(hours: DEFAULT_START_HOUR)

      day_assignments = day_assignments(day)
      day_assignments.each do |assignment|
        time_entry = build_time_entry(assignment, start_date)
        time_entries << time_entry

        start_date = start_date.advance(hours: time_entry.total_hours.to_f)
      end
      time_entries
    end

    def build_time_entry(assignment, start_date)
      project_id  = assignment["project_id"]
      task_id     = assignment["task_id"]
      hours       = assignment["hours"]
      stop_date   = start_date.advance(hours: hours)
      start_time  = sprintf "%02d%02d", start_date.hour, start_date.min
      stop_time   = sprintf "%02d%02d", stop_date.hour, stop_date.min

      TimeEntry.new(
        employee_id: employee_id,
        project_id:  project_id,
        task_id:     task_id,
        date:        start_date.to_date.to_s,
        total_hours: hours,
        start_time:  start_time,
        stop_time:   stop_time,
      )
    end

    def day_assignments(date)
      assignments[date.to_s] || assignments["default_day"]
    end
  end
end
