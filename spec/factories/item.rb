FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "Foobar#{n}" }
    description 'I am a foobar.'
    quantity 1
  end
end
