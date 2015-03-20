require 'test/unit'

class MyTest < Test::Unit::TestCase

  context 'new trend' do
    setup do
     @user =  User.new({email:'test1_user@test1_user.com', password: 'f4k3p455w0rd' })
     @user.save
    end

    should 'add the new trend' do
      trend = @user.add_trend('name_trend1', 'www.url.com')
      assert_equal 'name_trend1', trend.name
      assert_equal 'www.url.com', trend.url
    end
  end

  context 'already has a trend' do
    setup do
      @user1 =  User.new({email:'test2_user@test2_user.com', password: 'f4k3p455w0rd'})
      @user1.add_trend('name_trend2', 'www.url.com')
     @user1.save
    end

    should 'return nil' do
      trend = @user1.add_trend('name_trend2', 'www.url.com')
      assert_equal nil, trend
    end
  end

  context 'if exist the trend it is the same object' do
    setup do
      @user =  User.new({email:'test3_user@test3_user.com', password: 'f4k3p455w0rd' })
      @user.add_trend('name_trend3', 'www.url.com')
      @second_user = @user =  User.new({email:'test3_S_user@user.com', password: 'f4k3p455w0rd' })
      @second_user.add_trend('name_trend3', 'www.url.com')
      @user.save
      @second_user.save
    end

    should 'get the same trend' do
      assert_equal @user.trends.first, @second_user.trends.first
    end
  end

end