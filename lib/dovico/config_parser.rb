module Dovico
  class ConfigParser
    AVAILABLE_ACTIONS = [:myself, :tasks, :show, :fill, :submit, :clear]
    DATE_REQUIRED_ACTIONS = [:show, :fill, :submit, :clear]

    def initialize(config)
      @config = config
      @start_date, @end_date = parse_date_options
    end

    def needs_help?
      if config[:help]
        true
      elsif AVAILABLE_ACTIONS.map{|action| config[action] }.compact.empty?
        true
      elsif !(@start_date && @end_date) && !DATE_REQUIRED_ACTIONS.map{|action| config[action] }.compact.empty?
        true
      else
        false
      end
    end

    def date_options
      [start_date, end_date]
    end

    private
    attr_accessor :config, :start_date, :end_date

    def parse_date_options
      start_date, end_date = nil

      if config[:week]
        year = config[:year] || Date.current.year
        start_date = Date.commercial(year, config[:week]).beginning_of_week
        end_date = start_date.advance(days: 4)
      elsif config[:current_week]
        start_date = Date.current.beginning_of_week
        end_date = start_date.advance(days: 4)
      elsif config[:day]
        start_date = end_date = Date.parse(config[:day])
      elsif config[:today]
        start_date = end_date = Date.current
      elsif config[:start] && config[:end]
        start_date = Date.parse(config[:start])
        end_date = Date.parse(config[:end])
      end

      [start_date, end_date]
    end
  end
end
