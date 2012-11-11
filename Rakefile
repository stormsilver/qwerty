#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Qwerty::Application.load_tasks

task :add_twilio => :environment do
  numbers = [
    {:phone_number => "+18162956925", :twid => "PNe01f0cbcbb2a2b0947120c81f6b0bffb"},
    {:phone_number => "+18169740624", :twid => "PN77e4e1a146aa58e9f524c856aea8511b"},
    {:phone_number => "+18165699026", :twid => "PN67aa28312fd2982d20eb22b9c9159dd5"}
  ]
  numbers.each do |number|
    TwilioNumber.create(number)
  end
end

task :main_rx => :environment do
  from = ENV['from']
  to = ApplicationConfig['twilio_main_phone']
  body = ENV['body']
  if !from || !body
    ap "You need to specify 'from' and and 'body'"
    exit
  end

  Text.main_rx(from, to, body)
end

task :game_rx => :environment do
  from = ENV['from']
  to = ENV['to']
  body = ENV['body']
  if !from || !to || !body
    ap "You need to specify 'from' and 'to' and 'body'"
    exit
  end

  Text.game_rx(from, to, body)
end
