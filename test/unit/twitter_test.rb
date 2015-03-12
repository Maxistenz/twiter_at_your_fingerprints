require 'fakeweb'

require 'test_helper'

class TwitterTest < Test::Unit::TestCase

  setup do
    @twitter = Twitter.new
  end

  context 'reading trending' do

    setup do
      FakeWeb.
          register_uri(:get, 'https://api.twitter.com/1.1/trends/place.json?id=1',
                       [{body: open('test/fixtures/trend_body.txt', status: ['200', 'OK'])}])

    end

    should 'return 10 trends' do
      assert_equal 10, @twitter.trending_topics.size
    end

    should 'build trends with correct information' do
      trend = @twitter.trending_topics
      assert_equal 'Buywise', trend[9].name
      assert_equal 'http://twitter.com/search?q=Buywise', trend[9].url
    end

  end

  context 'reading tweets' do

    setup do
      FakeWeb.
          register_uri(:get, 'https://api.twitter.com/1.1/search/tweets.json?q=%23sport&count=10',
                   [{body: open('test/fixtures/tweets_body.txt', status: ['200', 'OK'])}])
    end

    should 'return 10 tweets' do
      tweets = @twitter.tweets('#sport', 10)
      assert_equal 10, tweets.size
    end

    should 'build tweet with correct information' do
      tweets = @twitter.tweets('#sport', 10)
      assert_equal 'Mencap MeTime South' , tweets[9].name
      assert_equal 'Thu Mar 12 16:20:11 +0000 2015' , tweets[9].created_at
      assert_equal 2917625703 , tweets[9].user_id
    end

  end

  context 'reading user bio' do

    setup do
      FakeWeb.
          register_uri(:get, 'https://api.twitter.com/1.1/users/show.json?screen_name=puntotweet',
                     [{body: open('test/fixtures/bio_body.txt', status: ['200', 'OK'])}])
    end

    should 'return name and description of the user' do
      result = @twitter.bio('puntotweet')
      assert_equal 'Punto Informatico', result.name
      assert_equal 'Il primo quotidiano italiano online di inform...', result.description
    end

  end

end