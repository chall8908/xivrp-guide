class Event < ApplicationRecord
  has_many :schedules

  def to_recurrent
    Montrose::Schedule.build do |schedule|
      schedules.each do |s|
        schedule << s.to_recurrent
      end
    end
  end

  def next_or_current_occurance
    Time.use_zone(timezone) do
      start_of_day = Time.now.beginning_of_day

      to_recurrent.lazy.find { |r| r.after? start_of_day }
    end
  end

end
