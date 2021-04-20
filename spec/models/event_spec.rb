require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'generates a slug automatically' do
    e = Event.create(name: 'Test Event',
                     description: 'this is a test',
                     server: 'Diabolos',
                     location: 'Somplace',
                     ward: 1,
                     plot: 1,
                     nearest_aetherite: 'Somewhere',
                     timezone: 'America/New_York',
                    )

    expect(e.slug).to_not be_nil
    expect(e.slug).to eq 'test-event'

    e.destroy
  end

  context '#next_or_current_occurance' do
    let(:event) { Event.new(timezone: 'America/New_York') }

    subject { event.next_or_current_occurance  }

    it 'returns nil when no occurance is on or after today' do
      event.schedules.build(start_date: Date.new(2020, 1, 1),
                            end_date: Date.new(2020,1,2),
                            start_time: Time.now.change(hour: 13, minute: 0, second: 0),
                            end_time: Time.now.change(hour: 14, minute: 0, second: 0),
                            monday: true,
                            repeat_unit: 'never',
                            repeate_interval: 0
                           )

      expect(subject).to be_nil
    end

    context 'next event is in the future' do
      it 'returns the next time an event is scheduled to start' do
        event.schedules.build(start_date: Date.new(3000, 1, 1),
                              end_date: Date.new(3000,1,2),
                              start_time: Time.now.change(hour: 13, minute: 0),
                              end_time: Time.now.change(hour: 14, minute: 0),
                              times: '1pm-2pm',
                              monday: true,
                              repeat_unit: 'never',
                              repeate_interval: 0
                             )

        expect(subject).to eq DateTime.new(3000, 1, 1, 13, 0, 0)
      end
    end
  end
end
