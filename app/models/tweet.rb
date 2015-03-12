class Tweet

  attr_accessor :name, :created_at, :text, :user_id, :tweet_id

  def initialize(name, created_at, text, user_id, tweet_id)
    @name = name
    @created_at = created_at
    @text = text
    @user_id = user_id
    @tweet_id = tweet_id
  end

end