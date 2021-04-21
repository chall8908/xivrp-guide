Sidekiq.configure_server do
  Sidekiq::Cron::Job.load_from_hash! Rails.application.configuration.job_schedule
end
