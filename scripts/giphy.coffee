# Description:
#   A way to search images on giphy.com
#
# Configuration:
#   HUBOT_GIPHY_API_KEY
#
# Commands:
#   hubot gif me <query> - Returns an animated gif matching the requested search term.

giphy =
  api_key: process.env.HUBOT_GIPHY_API_KEY
  base_url: 'http://api.giphy.com/v1'

module.exports = (robot) ->
  robot.hear /!giphy( me)? (.*)/i, (msg) ->
    if msg.message.room == 'C0Z77BT4M' or msg.message.room == 'C0Z77BT8V' or msg.message.room == 'Shell'
      giphyMe msg, msg.match[2], (url) ->
        msg.send url

giphyMe = (msg, query, cb) ->
  endpoint = '/gifs/search'
  url = "#{giphy.base_url}#{endpoint}"

  msg.http(url)
    .query
      q: query
      api_key: giphy.api_key
    .get() (err, res, body) ->
      response = undefined
      try
        response = JSON.parse(body)
        images = response.data
        if images.length > 0
          image = msg.random images
          cb image.images.original.url

      catch e
        response = undefined
        cb 'Error'

      return if response is undefined
