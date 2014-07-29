namespace :foreman do
  desc "Export the Procfile to initscript scripts"
  task :export do
    run "cd #{release_path} && foreman export initscript -a events_app -u #{ENV['PRODUCTION_USER']} x-42 -l #{shared_path}/log"
    sudo "cp #{release_path}/x-42/events_app /etc/init.d"
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

