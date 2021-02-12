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

site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/food-truck/'))
menu_lines = site.xpath('//ul[@class="featureddish"]/li')

res = []
menu_lines.each do |line|
  name = line.at_css('h6').content
  description = line.at_css('div.menu-description').content
  price = line.at_css('div.price')&.content || 'Pas de prix annoncé'
  image_url = line.at_css('a.pretty_image')&.attributes&.dig('href')&.content || ''

  res.append(Dish.new(name: name, description: description, price: price, image_url: image_url))
end

client.chat_postMessage(channel: '#random', blocks: res, as_user: true)
