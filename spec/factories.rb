require 'factory_girl'
require 'faker'
require File.dirname(__FILE__) + '/gni_factory_girl'


#### Sequences

Factory.sequence(:number)           { |n| n }
Factory.sequence(:string )          { |n| "unique#{ n }string" }
Factory.sequence(:scientific_name)  { |n| "#{Faker::Name.first_name} #{Faker::Name.last_name.downcase}" }
Factory.sequence(:url)              { |n| "http://#{Faker::Internet.domain_name}/data#{n}" }
Factory.sequence(:sha_hash)         { |n| Digest::SHA1.hexdigest(n.to_s) }

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

Factory.define :user do |user|
  user.created_at                   { rand(10).days.ago }
  user.updated_at                   { |r| r.created_at }
  user.name                         { Faker::Name.name }
  user.login                        { |r| Faker::Internet.user_name(r.name) }
  user.email                        { |r| Faker::Internet.email(r.name) }
  user.password                     { Factory.next(:string) }
  user.password_confirmation        { |r| r.password }
  user.crypted_password             { |r| Digest::SHA1.hexdigest(r.password) }
  user.salt                         { Factory.next(:sha_hash) }
  user.admin                        { rand(10) > 8 ? 1 : 0 }
  user.remember_token               { Factory.next(:string) }
  user.remember_token_expires_at    { rand(10).days.from_now }
end

Factory.define :data_source_contributor do |dso|
  dso.association       :user
  dso.association       :data_source
  dso.data_source_admin 0
end

Factory.define :name_index do |ni|
  ni.association  :name_string
  ni.association  :data_source
  ni.records_hash { Factory.next(:sha_hash) }
end

Factory.define :name_index_record do |nir|
  nir.association   :name_index
  nir.kingdom       nil
  nir.record_hash   nil
  nir.rank  do  
    rank_index = 0
    chance =  rand(100)
    ranks = ['Species', 'Genus', 'Order'] 
    rank_index = 1 if chance.between?(75,94)
    rank_index = 2 if chance.between?(95,100)
    ranks[rank_index]
  end
  nir.local_id    { Factory.next(:number) }
  nir.global_id   { Factory.next(:sha_hash) }
  nir.url         { Factory.next(:url) }
end

Factory.define :import_scheduler do |imps|
  imps.association :data_source
  imps.status      1
  imps.message     'Added to the que'
end