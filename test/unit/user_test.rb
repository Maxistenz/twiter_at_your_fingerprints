require 'test/unit'

class UserTest < Test::Unit::TestCase

  context 'new trend' do
    setup do
     @user =  FactoryGirl.create(:first_user)
    end

    should 'add the new trend' do
      first = FactoryGirl.build(:first_trend)
      trend = @user.add_trend(first.name, first.url)
      assert_equal first.name, trend.name
      assert_equal first.url, trend.url
    end
  end

  context 'already has a trend' do
    setup do
      @user =  FactoryGirl.create(:second_user)
      @trend = FactoryGirl.build(:first_trend)
      @user.add_trend(@trend.name, @trend.url)
    end

    should 'return nil' do
      trend = @user.add_trend(@trend.name, @trend.url)
      assert_equal nil, trend
    end
  end

  context 'if exist the trend it is the same object' do
    setup do
      @trend = FactoryGirl.build(:first_trend)
      @user = FactoryGirl.create(:fourth_user)
      @user.add_trend(@trend.name, @trend.url)
      @second_user = FactoryGirl.create(:fifth_user)
      @second_user.add_trend(@trend.name, @trend.url)
    end

    should 'get the same trend' do
      assert_equal @user.trends.first, @second_user.trends.first
    end
  end

end