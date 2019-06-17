class Friendship < ApplicationRecord
    
    enum status: [:pending, :accepted, :cancelled,:blocked]
    
    belongs_to :sender, class_name: "User" , foreign_key: 'user1_id'
    belongs_to :reciever, class_name: "User" , foreign_key: 'user2_id'

    validates :sender, presence: true
    validates :reciever, presence: true

    # this method will change the status of friendships 
    # pending(when adding creating a new frienship) 
    # accepted
    # cancelled
    # blocked
    def self.change_status(id,status)
      friendship = Friendship.find(id.to_i)
      friendship.status = status.to_i
      friendship
    end

    def self.cancel_friendship(id)
     
      friendship = Friendship.find(id.to_i)
  
      return friendship
    end

    def self.friend_list(user)

      friendship = Friendship.where("user1_id = ? AND status = 1 OR user2_id = ? AND status = 1 ",user.id,user.id)
      friendship
    end


  end