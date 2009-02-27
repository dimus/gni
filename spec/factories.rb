require 'factory_girl'
require 'faker'
require File.dirname(__FILE__) + '/gni_factory_girl'


#### Sequences

Factory.sequence(:string ){|n| "unique#{ n }string" }
Factory.sequence(:scientific_name){|n| "#{Faker::Name.first_name} #{Faker::Name.last_name.downcase}" }

#### Factories

Factory.define :name_string do |name_string|
  name_string.created_at      { 5.days.ago }
  name_string.updated_at      { 5.days.ago }
  name_string.name            { Factory.next(:scientific_name) }
  name_string.normalized_name { |ns| "#{NameString.normalize_name_string(ns.name)}" }#|ns| NameString.normalize_name_string(ns.name) }
end

