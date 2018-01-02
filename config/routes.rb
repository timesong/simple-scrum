# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:project_id/issues/scrum', :to => 'scrum#index', :as => 'project_scrum'
post '/scrum_update_pbis/:backlog_id', :to => 'backlog#update', :as => 'project_scrum_update_pbis'
post '/scrum-create-pbi/:backlog_id', :to => 'backlog#create', :as => 'project_scrum_create_pbi'
post '/scrum-backlog-to-sprint/:backlog_id', :to => 'backlog#move_to_sprint', :as => 'project_backlog_to_sprint'
