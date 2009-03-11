require 'factory_girl'
require 'faker'
require File.dirname(__FILE__) + '/gni_factory_girl'


#### Sequences

Factory.sequence(:string ){|n| "unique#{ n }string" }
Factory.sequence(:scientific_name){|n| "#{Faker::Name.first_name} #{Faker::Name.last_name.downcase}" }
Factory.sequence(:url){|n| "http://#{Faker::Internet.domain_name}/data#{n}"}

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
  user.crypted_password             { '324324abab' }
  user.salt                         { 'saltsalt' }
  user.admin                        { rand(10) > 8 ? 1 : 0 }
  user.remember_token               { Factory.next(:string) }
  user.remember_token_expires_at    { rand(10).days.from_now }
end