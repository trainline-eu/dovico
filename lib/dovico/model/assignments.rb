require 'fileutils'

module Dovico
  class Assignments
    class CacheError < RuntimeError; end

    attr_reader :assignments, :myself

    CACHE_FILE = "#{APP_DIRECTORY}/assignments.json"
    CACHE_VERSION = "2"

    def initialize(force_refresh: false)
      if !force_refresh
        load_from_cache!
      end

      @assignments ||= Assignment.fetch_all
      @myself ||= Employee.myself

      save_to_cache!
    end

    def format_tree
      assignments.map(&:to_s).join("\n")
    end

    def find_project_task(project_id, task_id)
      project = assignments.find {|assignment| assignment.find_object(Project, project_id) }
      task = project.find_object(Task, task_id)

      if project.nil? || task.nil?
        raise "Can't find project##{project_id}/task##{task_id}. Try with --force-refresh option"
      end

      [project, task]
    end

    private

    def load_from_cache!
      raise CacheError.new("Cache does not exist") unless File.exists?(CACHE_FILE)

      json = JSON.parse(File.read(CACHE_FILE))
      raise CacheError.new("Cache version mismatch") unless json["version"] == CACHE_VERSION

      @assignments = Assignment.unserialize(json["assignments"]) unless json["assignments"].nil?
      @myself = Employee.unserialize(json["myself"]) unless json["myself"].nil?
    rescue JSON::ParserError, CacheError => e
    end

    def save_to_cache!
      cache = {
        version:     CACHE_VERSION,
        assignments: @assignments,
        myself:      @myself,
      }

      FileUtils.mkdir_p(APP_DIRECTORY)
      File.write(CACHE_FILE, cache.to_json)
    end
  end
end
