module EventsHelper
  def server_options
    @server_options ||= Ffxiv::Utils.servers.transform_values { |v| v.map { [_1, _1.downcase] } }
  end

  DUMMY_DESCRIPTION = <<~DESC
  This is the description of the event.  It has some _markdown_ in it.

  * and also a list
  * because why not?
  DESC

  # Used for background previews
  def dummy_event(banner = nil)
    Event.new(name: 'Preview Event',
              slug: 'preview-event',
              description: DUMMY_DESCRIPTION,
              server: 'Server',
              location: 'location',
              ward: 0,
              plot: 0,
              banner: banner,
              nearest_aetherite: 'aetherite',
              schedule: IceCube::Schedule.new(Time.now, end_time: 1.hour.from_now) do |s|
                s.add_recurrence_rule(IceCube::Rule.weekly.day(*0..6))
              end.to_yaml,
              timezone: 'America/New_York',
              updated_at: Time.now
             )
  end
end
