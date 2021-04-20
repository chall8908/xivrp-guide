module EventViews
  class ShowView
    include ::RouteViewModelAsModel
    include Forwardable

    route_as :event

    attr_reader :schedule, :location, :banner_url, :start_time, :end_time

    delegate :<=>, :name, :description, :nearest_aetherite, :banner, :updated_at, to: :@event

    def self.build(events)
      events.map { new _1 }
    end

    def initialize(event)
      @event = event
      @schedule = @event.schedule_rules.to_s
      @start_time = @event.next_or_current_occurrence
      @end_time = @start_time + @event.schedule_rules.duration

      # @banner_url = @event.banner.url

      @location = @event.server.humanize
      @location += ', ' + @event.location
      @location += ", ward #{@event.ward}" if @event.ward.present?
      @location += ", plot #{@event.plot}" if @event.plot.present?
    end

    def record
      @event
    end

    def open_class
      now = Time.now

      # Handle events that don't occur at all today
      return 'closed' if @start_time > Date.tomorrow
      return 'open-soon' if @start_time > now
      return 'closed' if @end_time < now

      return 'open-now'
    end
  end
end
