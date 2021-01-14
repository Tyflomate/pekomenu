# frozen_string_literal: true

require 'json'

class Dish

  def initialize(name, description, price: '', image_url: '')
    @name = name
    @description = description
    @price = price
    @image_url = image_url
  end

  def json_with_image(_options = {})
    {
      "type": 'section',
      "text": {
        "type": 'mrkdwn',
        "text": "*#{@name}*\n\n#{@description}\n\n#{@price}"
      },
      "accessory": {
        "type": 'image',
        "image_url": @image_url,
        "alt_text": @name + ' image'
      }
    }
  end

  def json_without_image(_options = {})
    {
      "type": 'section',
      "text": {
        "type": 'mrkdwn',
        "text": "*#{@name}*\n\n#{@description}\n\n#{@price}"
      }
    }
  end

  def as_json(_options = {})
    if @image_url.empty?
      json_without_image
    else
      json_with_image
    end
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end