class User < ApplicationRecord

  has_many :sended_friend_requests, foreign_key: "user1_id",class_name: "Friendship"
  has_many :recieved_friend_requests, foreign_key: "user2_id",class_name: "Friendship"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:omniauthable, omniauth_providers: %i[facebook]


  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.photo = auth.info.image
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end

    else
      super
    end
  end

  # get all pending requests for a user
  def self.pending_friend_requests(user)
    user.recieved_friend_requests.where(status: Friendship.statuses[:pending])
  end
  
  # get all requests that you have sended to other users
  def self.sended_pending_friend_requests(user)
    user.sended_friend_requests.where(status: Friendship.statuses[:pending])
  end

  # get all friends that have been accepted
  def self.friend_list(user)
 
    lst = Array.new
    
    sended = user.sended_friend_requests.where(status: Friendship.statuses[:accepted])
    
    sended.each do |request|
     lst << request.reciever
    end

    recieved = user.recieved_friend_requests.where(status: Friendship.statuses[:accepted])

    recieved.each do |request|
      lst << request.sender
    end
    
    lst
  end

end
