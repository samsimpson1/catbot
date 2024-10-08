require "timezone"
require_relative "discord"
require_relative "config"

class TimeBot
  @@channel_id = DiscordAPI.channel_by_name Config["channel_name"]
  @@message_id

  def self.get_time_in(timezone_name)
    tz = Timezone[timezone_name]
    time = tz.utc_to_local(Time.now)
    return time.strftime("%H:%M")
  end

  def self.discord_timestamp
    time = Time.now.to_i
    return "<t:#{time}:t>"
  end

  def self.build_message
    time_zones = [
      {
        "name" => "Local Time",
        "value" => discord_timestamp
      }
    ]
    for tz in Config["time_zones"]
      time_zones.append({
        "name" => tz["name"],
        "value" => get_time_in(tz["tz"])
      })
    end

    return {
      "embeds" => [
        {
          "title" => "Time",
          "type" => "rich",
          "fields" => time_zones
        }
      ]
    }
  end

  def self.do_message
    contents = build_message
    @@message_id = DiscordAPI.find_own_message_in_channel @@channel_id
    puts "msgid"
    puts @@message_id
    if @@message_id != nil
      DiscordAPI.edit_message(@@channel_id, @@message_id, contents)
    else
      @@message_id = DiscordAPI.create_message(@@channel_id, contents)
    end
  end
end