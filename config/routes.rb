Rails.application.routes.draw do
  root to: "location#root"
  get 'location/:zip_code', :to => "location#show"
  get 'location/', :to => "location#show"
end
