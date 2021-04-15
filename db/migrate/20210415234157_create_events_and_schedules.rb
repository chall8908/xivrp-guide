class CreateEventsAndSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.string :server, null: false, comment: 'Which server the event takes place on'
      t.string :location, null: false, comment: 'Either a housing ward or a location in the world'
      t.integer :ward, comment: 'Ward number for venues'
      t.integer :plot, comment: 'Plot number for venues'
      t.string :nearest_aetherite, null: false

      t.string :timezone, null: false, comment: 'Timezone this event was scheduled in.  Shared by all schedules'

      t.timestamps
    end

    create_table :schedules do |t|
      t.belongs_to :event

      t.date :start_date, null: false, comment: 'First day this schedule is valid'
      t.date :end_date, comment: 'Last day this schedule is valid'
      t.string :times, null: false, comment: 'Time range this schedule represents'

      t.boolean :sunday, default: false
      t.boolean :monday, default: false
      t.boolean :tuesday, default: false
      t.boolean :wednesday, default: false
      t.boolean :thursday, default: false
      t.boolean :friday, default: false
      t.boolean :saturday, default: false

      t.integer :repeat_interval, null: false
      t.string :repeat_unit, null: false, comment: 'How often this schedule repeats: never, week, month, year'

      t.timestamps
    end

    add_foreign_key :schedules, :events
  end
end
