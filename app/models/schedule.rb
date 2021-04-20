class Schedule < ApplicationRecord
  belongs_to :event

  def to_recurrent
    repeat = case repeat_unit
             when 'never'
               1.week
             else
               repeat_interval.send(repeat_unit)
             end

    Montrose.r(every: repeat,
               on: days,
               starts: start_date,
               until: end_date,
               at: start_time.strftime('%r'),
               during: start_time..end_time)
  end

  private

  def days
    [].tap do |days|
      days << :sunday if sunday
      days << :monday if monday
      days << :tuesday if tuesday
      days << :wednesday if wednesday
      days << :thursday if thursday
      days << :friday if friday
      days << :saturday if saturday
    end
  end
end
