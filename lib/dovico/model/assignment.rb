require 'active_attr'

module Dovico
  class Assignment
    URL_PATH = 'Assignments'

    include ActiveAttr::Model

    attribute :id
    attribute :assignement_id
    attribute :name
    attribute :start_date
    attribute :finish_date


    def self.parse(hash)
      self.new(
        id:           hash["ItemID"],
        assignement_id: hash["AssignmentID"],
        name:         hash["Name"],
        start_date:   hash["StartDate"],
        finish_date:  hash["FinishDate"]
      )
    end
  end
end
