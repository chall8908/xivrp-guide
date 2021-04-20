class Event < ApplicationRecord
  def to_param; slug; end

  has_many :occurrences, dependent: :delete_all

  has_one_attached :banner

  attr_writer :schedule_rules

  before_validation :generate_slug, if: -> { self.slug.nil? or self.name_changed? }
  before_validation :serialize_schedule, unless: -> { self.schedule_rules.nil? }

  validates_presence_of(:slug, :name, :description, :server, :location, :timezone,
                        :nearest_aetherite, :schedule)

  before_save :update_occurrences, if: :schedule_changed?

  scope :active, -> (active_when = :today) do
    event_ids = case active_when
                when :today
                  Occurrence
                    .select(:event_id)
                    .where(%{ "date" = date_trunc('day', current_timestamp AT TIME ZONE "timezone") })
                    .distinct
                when :this_week
                  Occurrence
                    .select(:event_id)
                    .where('"date" BETWEEN ? AND ?', Date.today.beginning_of_week, Date.today.end_of_week)
                    .distinct
                when :next_week
                  Occurrence
                    .select(:event_id)
                    .where(%{ "date" BETWEEN date_trunc('day', current_timestamp) AT TIME ZONE "timezone" and date_trunc('day', current_timestamp AT TIME ZONE "timezone" + INTERVAL '1 week') })
                    .distinct
                when :at_all
                  Occurrence.select(:event_id).distinct
                end

    where(id: event_ids)
  end

  def schedule_rules
    @schedule_rules ||= Time.use_zone(timezone) do
      IceCube::Schedule.from_yaml(self.schedule)
    end
  end

  def next_or_current_occurrence
    schedule_rules.next_occurrence(Time.now.beginning_of_day)
  end

  def <=>(other_event)
    next_or_current_occurrence <=> other_event.next_or_current_occurrence
  end

  def generate_slug
    self.slug = self.name.parameterize
  end

  def serialize_schedule
    self.schedule = self.schedule_rules.to_yaml
  end

  # TODO: Move to worker
  def update_occurrences
    self.occurrences.delete_all

    future_occurrences = schedule_rules.occurrences_between(Time.now.beginning_of_day,
                                                            1.month.from_now,
                                                            spans: true)

    # No future occurences in the next month either means we don't have any more
    # or the next one isn't for a while.  Try to find it anyways
    future_occurrences << schedule_rules.next_occurrence if future_occurrences.empty?

    future_occurrences.each do
      # probably only happens if there aren't any more occurrences
      next if _1.nil?

      # These will all get saved when the event saves after the callback finishes
      self.occurrences.build(date: _1,
                             start_time: schedule_rules.start_time,
                             end_time: schedule_rules.end_time,
                             timezone: timezone
                            )
    end
  end

  def start_date
    return nil unless schedule.present?
    schedule_rules.first
  end

  def start_time
    return nil unless schedule.present?
    schedule_rules.start_time
  end

  def end_time
    return nil unless schedule.present?
    schedule_rules.end_time
  end

  def end_date
    return nil unless schedule.present?
    schedule_rules.last if schedule_rules.terminating?
  end

  # The implementation of these day methods are super brittle and tied directly
  # to the internal representation in IceCube.  Upgrading IceCube will very likely
  # cause all of these to break if they make any serious internal refactors.
  def monday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 1 }
  end
  alias_method :on_monday?, :monday

  def tuesday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 2 }
  end
  alias_method :on_tuesday?, :tuesday

  def wednesday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 3 }
  end
  alias_method :on_wednesday?, :wednesday

  def thursday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 4 }
  end
  alias_method :on_thursday?, :thursday

  def friday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 5 }
  end
  alias_method :on_friday?, :friday

  def saturday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 6 }
  end
  alias_method :on_saturday?, :saturday

  def sunday
    return false unless schedule.present?
    return false unless schedule_rules.rrules.present?

    schedule_rules.rrules.first.validations_for(:day).any? { _1.day == 7 }
  end
  alias_method :on_sunday?, :sunday

end
