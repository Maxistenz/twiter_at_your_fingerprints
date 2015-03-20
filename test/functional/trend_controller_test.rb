require 'test_helper'

class TrendControllerTest < ActionController::TestCase

  context 'User with no trend topic' do
    setup do
      user = User.new({email:'test@test.com', password: 'f4k3p455w0rd' })
      user.save

      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, {name:'#newTrend', url: 'www.fake.com'}
    end

    should 'associate the trend to the user' do
      query = User.joins(:trends).where('email = ? AND trends.name = ? AND trends.url = ?',
                                        'test@test.com','#newTrend', 'www.fake.com')
      assert_not_empty query
    end
  end

  context 'not insert equal trending topics' do
    setup do
      user = User.new({email:'test@test.com', password: 'f4k3p455w0rd' })
      user.save

      trend = Trend.new({name: '#newTrend', url: 'www.fake.com'})
      user.trends << trend

      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]

      post :create, {name:'#newTrend', url: 'www.fake.com'}

    end

    should 'only have one trend topic for user' do
      trends = User.joins(:trends).where('email = ? AND trends.name = ? AND trends.url = ?',
                                        'test@test.com','#newTrend', 'www.fake.com')
      assert_equal 1, trends.size
    end
  end

  context 'if exist a trending topic, not create other equal' do
    setup do
      user = User.new({email:'test@test.com', password: 'f4k3p455w0rd' })
      user.save

      trend = Trend.new({name: '#newTrend', url: 'www.fake.com'})
      user.trends << trend
      @trend_id = trend.id
      second_user = User.new({email: 'user@user.com', password: 'f4k3p455w0rd'})
      second_user.save

      sign_in second_user
      @request.env['devise.mapping'] = Devise.mappings[:second_user]
      post :create, {name:'#newTrend', url: 'www.fake.com'}
    end

    should 'asociate the same trend to second_user' do
      query = User.joins(:trends).where('email = ? AND trends.name = ? AND trends.url = ?',
                                        'user@user.com','#newTrend', 'www.fake.com')
      assert_equal 1, query.size

      query = User.joins(:trends).where('email = ? AND trends.name = ? AND trends.url = ?',
                                        'test@test.com','#newTrend', 'www.fake.com')
      assert_equal 1, query.size

      trends = Trend.where('name = ? AND url = ?','#newTrend', 'www.fake.com')
      assert_equal 1, trends.size
    end
  end

end
