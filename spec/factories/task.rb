FactoryBot.define do
  factory :task do
    title 'Title'
    description 'Description'
    deadline "2013,December,7"
    state 0
    priority 0
  end
end
