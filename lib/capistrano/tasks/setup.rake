namespace :setup do

  desc 'Call certain URL in order to force rails to warm up system'
  task :warm_cache do
    on roles(:web) do |host|
      execute "curl --silent -X GET -H \"Cache-Control: no-cache" "http://#{:application}/scores\""
      info "WARMED CACHE on host #{host}:\t"
    end
  end

end