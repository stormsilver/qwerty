#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Qwerty::Application.load_tasks

task :add_twilio => :environment do
  numbers = [
    {:phone_number => "8162956925", :twid => "PNe01f0cbcbb2a2b0947120c81f6b0bffb"},
    {:phone_number => "8169740624", :twid => "PN77e4e1a146aa58e9f524c856aea8511b"},
    {:phone_number => "8165699026", :twid => "PN67aa28312fd2982d20eb22b9c9159dd5"}
  ]
  numbers.each do |number|
    twi = TwilioNumber.new(number)
  end
end