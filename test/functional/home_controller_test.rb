require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  context 'list trending topics' do
    setup do
      FakeWeb.
          register_uri(:get, "https://api.twitter.com/1.1/trends/place.json?id=1",
                       [{:body => open('test/fixtures/trend_body.txt',
                                       :status => ["200", "OK"])}])
      user = FactoryGirl.create(:common)
      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]

      get :index
      @list_of_trending = assigns(:list_trending)
    end

    should 'get home' do
      assert_response :success
      assert_template %r{\Aindex\Z}
    end

    should 'contain some information' do
      assert_not_nil @list_of_trending
    end

    should 'contain the appropriate information' do
      assert_equal 10, @list_of_trending.size
      assert_equal '#TerryPratchett', @list_of_trending[0].name
    end

  end

  context 'list of tweets' do
    setup do
      url = "https://api.twitter.com/1.1/search/tweets.json?q=#sport&count=10"
      FakeWeb.
          register_uri(:get, URI.encode(url),
                       [{:body => open('test/fixtures/tweets_body.txt', :status => ["200", "OK"])}])
      user = FactoryGirl.create(:common)
      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]

      get(:tweets, trend_name: '#sport')
      @list_of_tweets = assigns(:list_tweets)
    end

    should 'get tweets' do
      assert_response :success
      assert_template %r{\Atweets\Z}
    end

    should 'contain some information' do
      assert_not_nil @list_of_tweets
    end

    should 'get tweets from #sport' do
      assert_equal 10, @list_of_tweets.size
      assert_equal 'Mencap MeTime South' , @list_of_tweets[9].name
    end
  end

  context 'reading twitter user bio' do
    setup do
      url = "https://api.twitter.com/1.1/users/show.json?screen_name=puntotweet"
      FakeWeb.
          register_uri(:get, URI.encode(url),
                       [{:body => open('test/fixtures/bio_body.txt', :status => ["200", "OK"])}])

      user = FactoryGirl.create(:common)
      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]

      get(:bio, {tweet_owner: 'puntotweet', trend_name: '#sport'})
      @user = assigns(:user)
    end

    should 'get bio' do
      assert_response :success
      assert_template %r{\Abio\Z}
    end

    should 'contain some information' do
      assert_not_nil @user
    end

    should 'get a bio from puntotweet' do
      assert_equal 'Punto Informatico', @user.name
    end
  end

end