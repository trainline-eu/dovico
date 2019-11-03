require 'active_attr'

module Dovico
  class Assignment
    URL_PATH = 'Assignments'

    include ActiveAttr::Model

    attribute :assignments

    attribute :id
    attribute :assignement_id
    attribute :get_assignments_uri
    attribute :name
    attribute :start_date
    attribute :finish_date

    def self.unserialize(assignments_hash)
      assignments_hash.map do |assignment_hash|
        assignments_array = assignment_hash.delete("assignments")

        assignment = class_for(assignment_hash["assignement_id"].chr).new(assignment_hash)
        assignment.assignments = unserialize(assignments_array)

        assignment
      end.sort_by(&:id)
    end

    def self.parse(hash)
      assignement_id = hash["AssignmentID"]

      class_for(assignement_id).new(
        id:                  hash["ItemID"],
        assignement_id:      assignement_id,
        get_assignments_uri: hash["GetAssignmentsURI"],
        name:                hash["Name"],
        start_date:          hash["StartDate"],
        finish_date:         hash["FinishDate"],
        assignments:         [],
      )
    end

    def self.class_for(assignement_id)
      case assignement_id.chr
      when 'P'
        Project
      when 'G'
        TaskGroup
      when 'T'
        Task
      when 'C'
        Client
      else
        raise "AssignmentID #{assignement_id} unsupported"
      end
    end
    private_class_method :class_for

    def self.fetch_assignments(assignments_path)
      assignments_list = ApiClient.get_paginated_list(assignments_path, "Assignments")

      assignments = assignments_list["Assignments"].map do |assignment_hash|
        assignment = parse(assignment_hash)

        if assignment.get_assignments_uri.present? &&
          assignment.get_assignments_uri != "N/A" &&
          !assignment.is_a?(Task)  # Task has EmployeeAssignment as assignements that are not useful to fetch

          assignment.assignments = fetch_assignments(assignment.get_assignments_uri)
        end

        assignment
      end

      assignments.sort_by(&:id)
    end
    private_class_method :fetch_assignments

    def self.fetch_all
      fetch_assignments(URL_PATH)
    end

    def find_object(klass, object_id)
      if self.is_a?(klass) && id == object_id
        self
      elsif assignments.present?
        assignments.find do |assignment|
          object = assignment.find_object(klass, object_id)

          break object if object.present?
        end
      end
    end

    def to_s(depth = 0)
      string = " " * depth*2 + "#{type} ##{id} #{name}"

      if assignments.present?
        string += "\n#{assignments.map {|a| a.to_s(depth + 1) }.join("\n")}\n"
      end

      string
    end

    private
    def type
      self.class.name.demodulize
    end

  end
end
