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
        intro: FFaker::Lorem.sentence,
        avatar: file,
      )
    end
    puts "Now have #{User.count} fake users in total."
  end
  
  task fake_post: :environment do
    Post.destroy_all
    rand(25..50).times do
      user = User.all.sample
      post = User.posts.build(
        title: FFaker::Book.title,
        content: FFkaer::Book.description,
        image: File.open(Rails.root.join("public/post-img/#{rand(1..15)}.jpg"))
        draft: [true, false, false, false].sample,
        privacy: rand(1..3)
      )
    end
    puts "created #{user.posts.count} #{user.name}'s posts"
  end

  
end