module EventQueries
  class << self
    def from_filters(filters, events = Event.all)
      events = self.active(filters[:active], events) if filters.has_key? :active

      events = self.server(filters[:server], events) if filters.has_key? :server

      events
    end

    def active(active_when = 'today', events = Event.all)
      event_ids = case active_when
                  when 'today'
                    Occurrence
                      .select(:event_id)
                      .where(%{ "date" = date_trunc('day', current_timestamp AT TIME ZONE "timezone") })
                      .distinct
                  when 'this_week'
                    Occurrence
                      .select(:event_id)
                      .where('"date" BETWEEN ? AND ?', Date.today.beginning_of_week, Date.today.end_of_week)
                      .distinct
                  when 'next_week'
                    Occurrence
                      .select(:event_id)
                     .where(%{ "date" BETWEEN date_trunc('day', current_timestamp AT TIME ZONE "timezone") AND date_trunc('day', current_timestamp AT TIME ZONE "timezone" + INTERVAL '1 week') })
                      .distinct
                  when 'at_all'
                    Occurrence.select(:event_id).distinct
                  end

      events.where(id: event_ids)
    end

    def server(server_name, events = Event.all)
      return events unless Ffxiv::Utils.is_server? server_name

      events.where(server: server_name)
    end
  end
end
