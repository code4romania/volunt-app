require 'net/https'

class SlackImport
  attr_reader :stats

  def initialize(users)
    @users = users
    @stats = {input_records: 0, users: 0, profiles: 0, coordinators: 0, errors: 0}
  end

  def import
    @users.each do |user_params|
      @stats[:input_records] += 1

      next if user_params["is_bot"] || user_params["name"] == "slackbot"
      p = user_params["profile"]

      email = p["email"]
      user = User.where(email: email).first

      unless user
        user = User.new(email: email)

        if user.save
          @stats[:users] += 1
        else
          log_error("Could not save user: #{user.attributes} #{user.errors.full_messages}")
        end
      end

      profile = Profile.where(email: email).first

      if profile
        # TODO maybe we can update some fields
      else
        profile = Profile.new(full_name: p["real_name"], email: email, title: p["title"],
                              nick_name: user_params["name"], is_volunteer: true)
        profile.is_coordinator = user_params["is_admin"]

        if profile.save
          @stats[:profiles] +=1
          @stats[:coordinators] += 1 if profile.is_coordinator?
        else

          Rails.logger.error("Could not save profile #{profile.attributes} #{profile.errors.full_messages}")
        end
      end
    end

    self
  end

  def log_error(str)
    @stats[:errors] += 1
    Rails.logger.error(str)
  end

  class << self
    def from_slack(token)
      url = "https://slack.com/api/users.list?token=#{token}&pretty=1"
      json = Net::HTTP.get(URI(url))
      from_str(json)
    end

    def from_file(path)
      File.open(path) do |file|
        return from_str(file.read)
      end
    end

    def from_str(text)
      new(JSON.parse(text)['members']).import
    end
  end
end
