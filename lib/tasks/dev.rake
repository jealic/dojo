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
    User.all.each do |user|
      rand(3..10).times do |i|
        Post.create!(
          user: user,
          title: FFaker::Book.title,
          content: FFaker::Book.description,
          draft: [true, false, false, false].sample,
          privacy: rand(1..3),
          image: File.open("#{Rails.root}/public/post-img/#{rand(1..15)}.jpg")
        )
      end
      puts "created #{user.name}'s #{user.posts.count} posts"
    end
  end

  task fake_post_category: :environment do
    Post.all.each do |post|
      post.categories << Category.all.sample
    end
    puts "All posts have a category."
  end

  
  task fake_reply: :environment do 
    Reply.destroy_all
    Post.where(draft: false).each do |post|
      rand(3..10).times do |i|
        Reply.create!(
          user: User.all.sample,
          comment: FFaker::Lorem.paragraph,
          post: post,
        )
      end
    end
    puts "replies to posts are created successfully."
  end

  task fake_friends: :environment do
    Friendship.destroy_all

    User.all.each do |user|
      user.friends << User.all.sample(rand(5..8))
    end
    # 每個 user 有不同數量的朋友們

    Friendship.all.each do |friendship|
      
      friendship.invite = ['pending', 'ignore', 'accept'].sample
      friendship.save
      if friendship.user_id == friendship.friend_id
        friendship.destroy
      end
    end
  end

  puts "All users have 5 to 8 friends."
  
end