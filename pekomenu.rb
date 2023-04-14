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

site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/camion/'))
menu_lines = site.css('.et_pb_with_background .et_pb_row .et_pb_blurb_content')

res = []
menu_lines.each do |line|
  name, price = line.at_css('h4 span').content.split(" | ")
  price = price || 'Pas de prix annoncé'
  description = line.at_css('.et_pb_blurb_description').content || ''
  image_url = line.at_css('img')&.attributes&.dig('src').content || ''

  res.append(Dish.new(name: name, description: description, price: price, image_url: image_url))
end

client.chat_postMessage(channel: '#cantine', blocks: res, as_user: true)
