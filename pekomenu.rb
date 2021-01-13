# frozen_string_literal: true

require 'slack-ruby-client'
require 'open-uri'
require 'nokogiri'
require 'reverse_markdown'
require 'dotenv'

Dotenv.load

client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
client.auth_test

site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/food-truck/'))
menu_lines = site.xpath('//ul[@class="featureddish"]/li')

bot_message = ReverseMarkdown.convert(menu_lines)

client.chat_postMessage(channel: '#testbot', text: bot_message, as_user: true)
