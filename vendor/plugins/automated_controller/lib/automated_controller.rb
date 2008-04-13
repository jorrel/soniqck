module AutomatedController

  AutomatedActions = %w(index)

  def self.included(base)
    base.extend AutomatedController::ClassMethods
  end

  module ClassMethods

    def automate(model = nil, options = {})
      model, options = nil, model if model.is_a?(Hash)
      model ||= infer_model_from_controller_name

      model_class = options[:class_name] || model.to_s.classify

      create_automated_actions model, model_class, options
    end

    protected

      def create_automated_actions(model, model_class, options)
        p_model = model.to_s.pluralize

        for action in options[:actions] || AutomatedController::AutomatedActions
          __send__ :"define_automated_#{action}_action", model, p_model, model_class, options
        end
      end

      def define_automated_index_action(model, p_model, model_class, options)
        self.class_eval <<-end_eval
          def index
            @#{p_model} = #{model_class}.paginate :page => params[:page]
          end
        end_eval
      end

      def infer_model_from_controller_name
        self.name.demodulize.underscore.sub(/_controller$/,'').to_sym
      end

  end

end