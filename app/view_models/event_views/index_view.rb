module EventViews
  class IndexView

    include Forwardable
    include Enumerable

    delegate :size, to: :@events

    def initialize(events)
      @events = ShowView.build(events)
    end

    def each
      @events.each { yield _1 }
    end

    alias_method :to_ary, :to_a
  end
end
