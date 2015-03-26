FactoryGirl.define do

  factory :trend do

    factory :first_trend do
      name '#firsTrend'
      url  'www.firstTrend.com'
    end

    factory :trending do
      name  '#nameOfTrendingTopic'
      url 'www.fake.com'
    end

  end

end