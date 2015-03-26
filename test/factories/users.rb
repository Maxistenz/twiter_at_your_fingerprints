FactoryGirl.define do

  factory :user do

    factory :administrator do
      email 'admin@test.com'
      password 'f4k3p455w0rd'
      admin true
    end

    factory :common do
      email 'user@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

    factory :first_user do
      email 'first@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

    factory :second_user do
      email 'second@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

    factory :third_user do
      id 1
      email 'third@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

    factory :fourth_user do
      email 'fourth@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

    factory :fifth_user do
      email 'fifth@test.com'
      password 'f4k3p455w0rd'
      admin false
    end

  end

end