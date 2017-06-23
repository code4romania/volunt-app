module ActiveRecord
  module Tasks # :nodoc:
    module DatabaseTasks

      private

      def each_current_configuration(environment)
        environments = [environment]
        configurations = ActiveRecord::Base.configurations.values_at(*environments)
        configurations.compact.each do |configuration|
          yield configuration unless configuration['database'].blank?
        end
      end
    end
  end
end