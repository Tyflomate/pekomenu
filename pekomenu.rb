require 'slack-ruby-bot'
require 'open-uri'
require 'nokogiri'

# le menu est dans l'ul featureddish
site = Nokogiri::HTML.parse(URI.open('https://www.pekopeko.fr/food-truck/'))

menu_lines = site.xpath("//ul[@class=\"featureddish\"]/li")
res = menu_lines.each do |line|
  dish_name = "# #{line.at_css("h6").content} #"
  dish_description = line.at_css("div.menu-description").content
  dish_price = line.at_css("div.price") != nil ? line.at_css("div.price").content : " Pas de prix annoncé"
  dish_image = line.at_css("a.pretty_image") != nil ? "![alt text](#{line.at_css("a.pretty_image").attributes["href"].content} \"Dish\")" : ""

  puts dish_name << "\n\n" << dish_description << "\n\n" << dish_price << "\n\n" << dish_image << "\n\n"
end

res