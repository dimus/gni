ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'data_sources'
  
  map.resources :access_rules

  map.resources :access_types, :has_many => :access_rules

  map.resources :participant_contacts

  map.resources :data_providers, :has_many => :data_provider_roles 

  map.resources :data_provider_roles

  map.resources :organizations

  map.resources :people

  map.resources :participants, :has_many => :participant_contacts
  
  map.resources :participant_people #, :has_many => [:people, :participant_contacts]
  
  map.resources :participant_organizations #, :has_many => [:organizations, :participant_contacts]

  map.resources :data_sources #, :has_many => [:data_providers, :access_rules]

  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
