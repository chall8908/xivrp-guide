class UpdateOccurrencesJob < ApplicationJob
  def perform
    ids = Event.pluck(:id)

    ids.map { ExecuteUpdate.perform_later(_1) }
  end

  class ExecuteUpdate < ApplicationJob
    def perform(event_id)
      Event.transaction do
        e = Event.find(event_id)
        e.update_occurrences!
        e.save!
      end
    end
  end
end
