require 'oauth'
require 'rubygems'
require 'trend'
require 'tweet'
require 'uri'

class Twitter

  def initialize
    @configuration = YAML.load(File.open('config/configuration.yml'))['client']
  end

  # Queries and returns the trendings topic of twitter
  #
  # @return [Array] with the information of the trending topics
  def trending_topics
    response = access_token.
       request(:get,
               @configuration['base_url_v'] + 'trends/place.json?id=' + @configuration['woeid'])
    response_json = JSON.parse(response.body)
    response_json[0]['trends'].map do |trend|
      Trend.new(trend['name'], trend['url'])
    end
  end

  # Searches and returns the most recent tweets
  #
  # @param hashtag [String] the hashtag to consult
  # @param n [Fixnum] the number of tweets
  #
  # @return [Array] with the information of the tweets
  def tweets(hashtag, n)
    response = access_token.
       request(:get, URI.encode(@configuration['base_url_v'] +
                                "search/tweets.json?q=#{hashtag}&count=#{n}"))
    response_json = JSON.parse(response.body)
    response_json['statuses'].map do |status|
      Tweet.new(status['user']['name'], status['created_at'],
                status['text'], status['user']['id'], status['id'])
    end
  end

  # Queries and returns the relevant information of a user.
  #
  # @param name [String] the twitter name of the user
  #
  # @return [Hash] with the relevant information of the user
  def bio(name)
    response = access_token.
        request(:get,
                URI.encode(@configuration['base_url_v'] + "users/show.json?screen_name=#{name}"))
    response_json = JSON.parse(response.body)
    TwitterUser.new(response_json['name'], response_json['description'])
  end

  # Sets the authentication to perform queries
  #
  # @return [OAuth::AccessToken]
  private
  def access_token
    consumer = OAuth::Consumer.
        new(@configuration['client_id'], @configuration['client_secret'],
            {site:  @configuration['base_url'], scheme: :header})

    token_hash = { oauth_token: @configuration['oauth_token'],
                   oauth_token_secret: @configuration['oauth_token_secret'] }

    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

end