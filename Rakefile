#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Qwerty::Application.load_tasks

task :add_twilio => :environment do
  TwilioNumber.delete_all
  numbers = [
    {:phone_number => "+18162956925", :twid => "PNe01f0cbcbb2a2b0947120c81f6b0bffb"},
    {:phone_number => "+18169740624", :twid => "PN77e4e1a146aa58e9f524c856aea8511b"},
    {:phone_number => "+18165699026", :twid => "PN67aa28312fd2982d20eb22b9c9159dd5"},
    {:phone_number => "+19136672961", :twid => "PN67cc54f27f793f9a09567ead28aa56f3"},
    {:phone_number => "+19136677041", :twid => "PN93e7553f2a3ae7acb671f47c048990cc"}
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

task :kill_old_games => :environment do
  time = ENV['minutes'].to_i
  if not time
    time = 10
  end
  ap time
  Game.kill_old_games(ENV['verbose'] == "true")
end

task :slam => :environment do
  order = [
  "+18162132421",
  "+18162132422",
  "+18162132421",
  "+18162132423",
  "+18162132424",
  "+18162132425",
  "+18162132424",
  "+18162132426",
  "+18162132421",
  "+18162132424"]
  order.each do |num|
    Text.main_rx(num, ApplicationConfig['twilio_main_phone'], "Start")
  end
end

task :sandbox => :environment do
  ap TwilioNumber.get_numbers
end