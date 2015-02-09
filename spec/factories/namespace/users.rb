FactoryGirl.define do
  factory 'namespace/user' do
    trait :valid do
      username 'anything'
    end
  end
end

