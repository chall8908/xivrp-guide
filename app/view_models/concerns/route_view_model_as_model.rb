# Handles setting up various routing helpers on a view model so that it routes
# as if it were a model.  This model _should_ be a property of the view model
module RouteViewModelAsModel
  extend ActiveSupport::Concern

  included do
    class_attribute :model_name
  end

  class_methods do

    # name   - the name of the model we're pretending to route as
    # record - the name of the internal variable or method to use
    def route_as name, record = :"@#{name}"
      self.model_name = name.to_s.freeze

      # Necessary for linking with link_to
      define_method(:to_model) do
        return public_send(record) if self.respond_to?(record)

        instance_variable_get(record)
      end

      # Necessary for the *_path helpers to work
      delegate :to_param, to: record
    end
  end
end
