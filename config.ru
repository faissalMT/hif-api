RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
require './lib/loader.rb'

run DeliveryMechanism::WebRoutes
