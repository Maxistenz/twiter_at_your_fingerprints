class HomeController < ApplicationController

  before_filter :init

  def index
    @list_trending = @twitter.trending_topics
  end

  def tweets
    @list_tweets = @twitter.tweets(params[:trend_name] , 10)
  end

  def bio
    @user = @twitter.bio(params[:tweet_owner])
  end

  private
  def init
    @twitter = Twitter.new
  end

end
