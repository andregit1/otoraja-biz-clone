module TaskLogging
  def task(*args, &block)
    Rake::Task.define_task(*args) do |task|
      if block_given?
        Rails.logger.info "#{Rails.env}"
        Rails.logger.debug "[#{task.name}] started"
        begin
          block.call(task)
          Rails.logger.debug "[#{task.name}] finished"
        rescue => exception
          Rails.logger.error "[#{task.name}] failed"
          Rails.logger.error exception
          Rails.logger.error exception.backtrace.join("\n")
          raise exception
        end
      end
    end
  end
end

# Override Rake::DSL#task to inject logging
extend TaskLogging
