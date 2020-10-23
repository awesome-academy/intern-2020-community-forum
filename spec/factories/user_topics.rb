FactoryBot.define do
  factory :user_topic do
    user_id {Faker::Number.between from: 0, to: 1}
    topic_id {Faker::Number.between from: 0, to: 1}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
  end
end
