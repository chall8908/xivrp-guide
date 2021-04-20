class CreateEventsAndOccurrences < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :slug, null: false, unique: true
      t.string :name, null: false
      t.string :description, null: false

      t.string :server, null: false, comment: 'Which server the event takes place on'
      t.string :location, null: false, comment: 'Either a housing ward or a location in the world'
      t.integer :ward, comment: 'Ward number for venues'
      t.integer :plot, comment: 'Plot number for venues'
      t.string :nearest_aetherite, null: false, comment: 'The nearest aetherite or aethernet node to the location'

      t.string :schedule, null: false, comment: 'Serialized schedule for this event'

      t.string :timezone, null: false, comment: 'Timezone this event was scheduled in.  Shared by all schedules'

      t.timestamps
    end

    create_table :occurrences do |t|
      t.belongs_to :event

      t.date :date, null: false, comment: 'The date this occurance takes place'
      t.time :start_time, null: false, comment: 'The time this scheduled event starts'
      t.time :end_time, null: false, comment: 'The time this scheduled event ends'

      t.string :timezone, null: false, comment: 'The time zone this occurance is in'

      t.timestamps
    end

    add_foreign_key :occurrences, :events
  end
end
