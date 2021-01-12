require 'slack-ruby-bot'
require 'open-uri'
require 'nokogiri'
require 'reverse_markdown'

site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/food-truck/'))
menu_lines = site.xpath("//ul[@class=\"featureddish\"]/li")

puts ReverseMarkdown.convert(menu_lines)