require "yaml"
require "json"
require "http"
require_relative "config"

class DiscordAPI
  @@http = HTTP.auth("Bot #{Config['client_secret']}")

  def self.channels
    r = @@http.get("https://discord.com/api/guilds/#{Config["guild_id"]}/channels")
    return JSON.load(r.body.to_s)
  end

  def self.channel_by_name(name)
    for channel in channels
      if channel["name"] == name
        return channel["id"]
      end
    end
  end

  def self.find_own_message_in_channel(channel_id)
    user_id = Config["client_id"]
    r = @@http.get("https://discord.com/api/channels/#{channel_id}/messages")
    messages = JSON.load(r.body.to_s)
    for message in messages
      if message["author"]["id"] == user_id
        return message["id"]
      end
    end
    return nil
  end

  def self.edit_message(channel_id, message_id, contents)
    @@http.patch(
      "https://discord.com/api/channels/#{channel_id}/messages/#{message_id}",
      :json => contents
    )
  end

  def self.create_message(channel_id, contents)
    r = JSON.load(@@http.post(
      "https://discord.com/api/channels/#{channel_id}/messages",
      :json => contents
    ).body.to_s)
    return r["id"]
  end
end