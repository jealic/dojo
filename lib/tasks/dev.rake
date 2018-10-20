namespace :dev do
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed"
  ]

  task fake_user: :environment do 
    Reply.destroy_all
    Post.destroy_all
    User.all.each do |user|
      user.destroy unless user.admin?
    end
    19.times do |i|
      user_name = FFaker::Name.first_name
      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      User.create!(
        name: user_name,
        email: "#{user_name}@example.com",
        password: "12345678",
        description: FFaker::Lorem.sentence,
        avatar: file,
      )
    end
    puts "have created #{User.count}fake users."
  end
    
    task fake_post: :environment do
      Post.destroy_all
      rand(50..100).times do
        user = User.all.sample
        post = User.posts.build(
          title: FFaker::unique.author,
          description: FFkaer::Book.description
        )
      end
    end

end