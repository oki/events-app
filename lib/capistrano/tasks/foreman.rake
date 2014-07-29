namespace :foreman do
  desc "Export the Procfile to initscript scripts"
  task :export do
    on roles(:app) do
      within release_path do
        execute :bundle, "exec foreman export initscript -a events_app -u #{ENV['PRODUCTION_USER']} x-42 -l #{shared_path}/log"
        sudo "cp #{release_path}/x-42/events_app /etc/init.d"
        sudo "chmod 755 /etc/init.d/events_app"
      end
    end
  end

  # desc "Start the application services"
  # task :start do
  #   sudo "service events_app start"
  # end

  # desc "Stop the application services"
  # task :stop do
  #   sudo "service events_app start"
  # end
end

