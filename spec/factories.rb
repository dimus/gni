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

Factory.define :canonical_form do |canonical_form|
  canonical_form.name { Factory.next(:scientific_name) }
end

Factory.define :name_string do |name_string|
  name_string.created_at      { 5.days.ago }
  name_string.updated_at      { 5.days.ago }
  name_string.name            { Factory.next(:scientific_name) }
  name_string.normalized_name { |ns| "#{NameString.normalize_name_string(ns.name)}" }
  name_string.association :canonical_form
end

Factory.define :lexical_group do |lexical_group|
  lexical_group.supercedure_id { nil }
end

Factory.define :lexical_group_name_string do |lgns|
  lgns.association :name_string
  lgns.association :lexical_group
end

Factory.define :data_source do |data_source|
  data_source.created_at          { 5.days.ago }
  data_source.updated_at          { 5.days.ago }
  data_source.refresh_period_days {14}
  data_source.title               { Factory.next(:string) }
  data_source.data_url            { Factory.next(:url) + ".xml" }
  data_source.logo_url            { Factory.next(:url) + ".jpg" }
  data_source.web_site_url        { Factory.next(:url) }
  data_source.unique_names_count  {10}
  data_source.name_strings_count  {10}
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

Factory.define :name_rank do |nr|
  nr.name       {Factory.next(:string)}
end

Factory.define :kingdom do |k|
  k.name {Factory.next(:string)}
end

Factory.define :name_index_record do |nir|
  nir.association   :name_index
  nir.association   :kingdom
  nir.association   :name_rank
  nir.record_hash   nil
  nir.local_id    { Factory.next(:number) }
  nir.global_id   { Factory.next(:sha_hash) }
  nir.url         { Factory.next(:url) }
end

Factory.define :import_scheduler do |imps|
  imps.created_at  { rand(30).days.ago }
  imps.association :data_source
  imps.status      1
  imps.message     'Added to the que'
end