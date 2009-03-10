require 'factory_girl'
require 'faker'
require File.dirname(__FILE__) + '/gni_factory_girl'


#### Sequences

Factory.sequence(:string ){|n| "unique#{ n }string" }
Factory.sequence(:scientific_name){|n| "#{Faker::Name.first_name} #{Faker::Name.last_name.downcase}" }
Factory.sequence(:url){|n| "http://#{Faker::Lorem.words(1)}.#{['org','com','net'].shuffle[0]}/data#{n}"}

#### Factories

Factory.define :name_string do |name_string|
  name_string.created_at      { 5.days.ago }
  name_string.updated_at      { 5.days.ago }
  name_string.name            { Factory.next(:scientific_name) }
  name_string.normalized_name { |ns| "#{NameString.normalize_name_string(ns.name)}" }
end

Factory.define :data_source do |data_source|
  data_source.created_at      { 5.days.ago }
  data_source.updated_at      { 5.days.ago }
  data_source.title           { Factory.next(:string) }
  data_source.data_url        { Factory.next(:url) + ".xml" }
  data_source.logo_url        { Factory.next(:url) + ".jpg" }
  data_source.web_site_url    { Factory.next(:url) }
end
