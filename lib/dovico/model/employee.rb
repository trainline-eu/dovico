module Dovico
  class Employee < Assignment
    URL_PATH = 'Employees'

    include ActiveAttr::Model

    attribute :id
    attribute :first_name
    attribute :last_name

    def self.parse(hash)
      Employee.new(
        id:         hash["ID"],
        first_name: hash["FirstName"],
        last_name:  hash["LastName"],
      )
    end

    def self.myself
      employees = ApiClient.get("#{URL_PATH}/Me")

      parse(employees["Employees"].first)
    end

    def self.unserialize(employee_hash)
      Employee.new(employee_hash)
    end

    def to_s
%{ - ID:         #{id}
 - First Name: #{first_name}
 - Last Name:  #{last_name}}
    end
  end
end
