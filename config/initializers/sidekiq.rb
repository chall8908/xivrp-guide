Sidekiq.configure_server do
  Sidekiq::Cron::Job.load_from_hash! Rails.configuration.job_schedule
end
