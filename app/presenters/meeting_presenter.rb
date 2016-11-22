class MeetingPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation
  include ActiveModel::Validations

  attr_accessor :meeting, :fellows

  # Trick polimorphic_url to think we're a 'meeting'
  delegate :persisted?, :model_name, :to_param, to: :meeting

  # make fields_for happy
  def fellows_attributes=(fellows)
    raise 'Should never be called'
  end

  def self.create_new(current_user_profile = nil)
    fellows = []
    fellows << MeetingFellowPresenter.new(current_user_profile.id) unless current_user_profile.nil?
    MeetingPresenter.new(
        meeting: Meeting.new,
        fellows: fellows)
  end

  def self.load_meeting(id)
    meeting = Meeting.find id
    fellows = []
    meeting.profiles.each do |p|
      fellows << MeetingFellowPresenter.new(profile_id: p.id)
    end
    MeetingPresenter.new(meeting: meeting, fellows: fellows)
  end

  def assign_params(params)
    self.meeting.assign_attributes(MeetingPresenter.meeting_params(params))
    fellows = []
    Rails.logger.debug(params.inspect)
    MeetingPresenter.fellows_params(params).each do |p|
      next if p[:profile_id].blank?
      fellows << MeetingFellowPresenter.new(profile_id: p[:profile_id])
    end
    self.fellows = fellows
  end

  def add_fellow
    self.fellows << MeetingFellowPresenter.new
  end

  def fellow_ids
    self.fellows.inject([]) do |arr,p|
      next if p.profile_id.blank?
      arr << p.profile_id
    end
  end

  def save
    # Deffered association save, since ActiveRecord lacks
    self.meeting.updated_at_will_change!
    self.meeting.singleton_class.before_save do
      profile_ids = self.fellow_ids
      self.meeting.profile_ids = profile_ids
    end
    self.meeting.save
  end


  class MeetingFellowPresenter
    include ActiveModel::Model
    include ActiveModel::AttributeMethods
    include ActiveModel::Translation
    include ActiveModel::Validations

    attr_accessor :profile_id

  end

  private

  def self.fellows_params(params)
    params.require(:meeting_presenter).fetch(:fellows, [])
  end

  def self.meeting_params(params)
    params.require(:meeting_presenter).require(:meeting).permit(
      :date,
      :agency,
      :location,
      :attendees_string,
      :summary,
      :notes,
      :attn_coordinators,
      :tags_string)
  end

end
