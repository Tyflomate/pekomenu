# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'slack-ruby-client'
require 'open-uri'
require 'nokogiri'
require 'dotenv'
require_relative 'dish'

Dotenv.load

client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
client.auth_test

site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/food-truck/'))
menu_lines = site.xpath('//ul[@class="featureddish"]/li')

res = []
menu_lines.each do |line|
  dish_name = line.at_css('h6').content
  dish_description = line.at_css('div.menu-description').content
  dish_price = !line.at_css('div.price').nil? ? line.at_css('div.price').content : 'Pas de prix annoncé'
  dish_image = !line.at_css('a.pretty_image').nil? ? line.at_css('a.pretty_image').attributes['href'].content : ''

  res.append(Dish.new(dish_name, dish_description, price: dish_price, image_url: dish_image))
end

client.chat_postMessage(channel: '#testbot', blocks: res, as_user: true)
