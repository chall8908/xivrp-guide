class EventsController < ApplicationController
  load_and_authorize_resource only: %i[ new create ]

  def index
    authorize! :read, Event

    @events = EventViews::IndexView.new(Event.active)
  end

  def show
    event = Event.find_by(slug: params[:slug])

    authorize! :read, event

    @event = EventViews::ShowView.new(event)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Unable to find an event with the slug: #{params[:slug]}"
    redirect_to :back
  end

  def new
    # @event is loaded by load_resource

    # Small dummy schedule to make the form a little nicer
    @event.schedule = IceCube::Schedule.new(Date.today).to_yaml
  end

  def create
    # @event is loaded by load_resource

    @event.schedule_rules = build_schedule

    @event.save!

    flash[:success] = "Successfully created #{@event.name}"

    redirect_to @event
  rescue => e
    flash.now[:error] = "Unable to create event: #{e.message}"

    @error = e
    render 'new'
  end

  def edit
    @event = Event.find_by(slug: params[:slug])

    authorize! :edit, @event

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Unable to find an event with the slug: #{params[:slug]}"
    redirect_to :back
  end

  def update
    @event = Event.find_by(slug: params[:slug])

    authorize :update, @event

    @event.assign_attributes(create_params)
    @event.schedule_rules = build_schedule

    @event.save!

    flash[:success] = "Successfully updated #{@event.name}"

    redirect_to @event

  rescue => e
    flash.now[:error] = "Unable to update event: #{e.message}"

    @error = e
    render 'edit'
  end

  def destroy
    @event = Event.find_by(slug: params[:slug])

    authorize! :destroy, @event

    @event.destroy

    flash[:success] = "Deleted #{event.name}"

    respond_to do |f|
      f.html do
        redirect_to 'root'
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to do |f|
      f.html do
        flash[:error] = "Unable to find an event with the slug: #{params[:slug]}"
        redirect_to :back
      end
    end
  end

  private

  def create_params
    params.require(:event).permit(:name, :description, :server, :location, :ward,
                                  :plot, :timezone, :banner, :nearest_aetherite)
  end

  def schedule_params
    params.require(:event).permit(:start_date, :start_time, :end_date, :end_time,
                                  :monday, :tuesday, :wednesday, :thursday, :friday,
                                  :saturday, :sunday)
  end

  def build_schedule
    # This part is _extremently important_
    # All time math must be done in the event's timezone or nothing will work out
    Time.use_zone(@event.timezone) do
      schedule = schedule_params

      start_time = Time.zone.parse(schedule[:start_date] + 'T' + schedule[:start_time])
      # End time is only used for the time part, not the date part
      end_time = Time.zone.parse(schedule[:start_date] + 'T' + schedule[:end_time])

      rrule = IceCube::Rule.weekly

      days = []
      days << :monday if schedule[:monday] == '1'
      days << :tuesday if schedule[:tuesday] == '1'
      days << :wednesday if schedule[:wednesday] == '1'
      days << :thursday if schedule[:thursday] == '1'
      days << :friday if schedule[:friday] == '1'
      days << :saturday if schedule[:saturday] == '1'
      days << :sunday if schedule[:sunday] == '1'

      rrule.day(days)

      if schedule[:end_date].present?
        rrule.until(Time.zone.parse(schedule[:end_date] + 'T' + schedule[:end_time]))
      end

      IceCube::Schedule.new(start_time, end_time: end_time) do |s|
        s.add_recurrence_rule(rrule)
      end
    end
  end
end
