namespace :dev do
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed"
  ]

  
end