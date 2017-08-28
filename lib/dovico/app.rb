require 'easy_app_helper'
require 'highline'

module Dovico
  class App
    include EasyAppHelper

    NAME = 'Dovico Simple Client'
    DESCRIPTION = <<EOL
Simple client for Dovico TimeSheet web application.

Please refer to the README.md page to setup your client.

WARNING: --auto and --simulate options are not effective.
EOL

    def initialize
      config.config_file_base_name = 'dovico'
      config.describes_application app_name: NAME,
                                   app_version: Dovico::VERSION,
                                   app_description: DESCRIPTION
      add_script_options

      ApiClient.initialize!(config["client_token"], config["user_token"])
    end

    def add_script_options
      config.add_command_line_section('Display informations') do |slop|
        slop.on :myself, 'Display info on yourself', argument: false
        slop.on :tasks,  'Display info on tasks',    argument: false
      end
      config.add_command_line_section('Fill the timesheets') do |slop|
        slop.on :fill,         'Fill the timesheet', argument: false
      end
      config.add_command_line_section('Show the timesheets') do |slop|
        slop.on :show,         'Show the filled timesheets', argument: false
      end
      config.add_command_line_section('Submit the timesheets') do |slop|
        slop.on :submit,       'Submit timesheets', argument: false
      end
      config.add_command_line_section('Clear the timesheets') do |slop|
        slop.on :clear,        'Clear the timesheets', argument: false
      end
      config.add_command_line_section('Date options (required for --show, --fill, --submit and --clear)') do |slop|
        slop.on :current_week, 'Current week', argument: false
        slop.on :today,        'Current day',  argument: false
        slop.on :day,          'Specific day', argument: true
        slop.on :start,        'Specific start day', argument: true
        slop.on :end,          'Specific end day', argument: true
        slop.on :week,         'Specific "commercial" week. See https://www.epochconverter.com/weeks/',  argument: true, as: Integer
        slop.on :year,         '[optional] Specifiy year (for --week option), default current year',  argument: true, as: Integer
      end
    end

    def run
      settings = ConfigParser.new(config)
      start_date, end_date = settings.date_options

      if settings.needs_help?
        display_help
        exit 0
      end

      if config[:myself]
        display_myself
      end

      if config[:tasks]
        display_tasks
      end

      if config[:clear]
        clear_time_entries(start_date, end_date)
      end

      if config[:show]
        display_time_entries(start_date, end_date)
      end

      if config[:fill]
        time_entry_generator = TimeEntryGenerator.new(
          assignments: config["assignments"],
          employee_id: myself.id,
        )
        time_entries = time_entry_generator.generate(start_date, end_date)

        saved_time_entries = TimeEntry.batch_create!(time_entries)
        puts "#{saved_time_entries["TimeEntries"].count} Entries created between #{start_date} and #{end_date}"
      end

      if config[:submit]
        submitted_time_entries = TimeEntry.submit!(myself.id, start_date, end_date)
        puts "#{submitted_time_entries["TimeEntries"].count} Entries submitted between #{start_date} and #{end_date}"
      end
    end

    private

    def myself
      @myself ||= Employee.myself
    end

    def display_myself
      puts "Informations about yourself"
      puts myself
      puts ""
    end

    def display_tasks
      puts "== List of available projects =="
      puts Project.format_all
      puts ""
    end

    def display_time_entries(start_date, end_date)
      puts "== List of Time Entries between #{start_date} and #{end_date} =="
      formatter = TimeEntryFormatter.new(Project.all)
      time_entries = TimeEntry.search(start_date, end_date)
      puts formatter.format_entries(time_entries)
      puts ""
    end

    def clear_time_entries(start_date, end_date)
      time_entries = TimeEntry.search(start_date, end_date)
      if highline.agree("• #{time_entries.count} Time Entries to be deleted. Are you sure? (yes/no)")
        time_entries.each do |time_entry|
          time_entry.delete!
        end
        puts "✓ #{time_entries.count} Time Entries deleted"
      end
    end

    def display_help
      puts config.command_line_help
    end

    def highline
      @highline ||= HighLine.new
    end
  end
end
