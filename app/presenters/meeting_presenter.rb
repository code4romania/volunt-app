class MeetingPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation
  include ActiveModel::Validations

  attr_accessor :meeting

  # Trick polimorphic_url to think we're a 'meeting'
  delegate :persisted?, :model_name, :to_param, to: :meeting


  def self.create_new(current_user_profile = nil)
    MeetingPresenter.new(meeting: Meeting.new)
  end

  def self.load_meeting(id)
    meeting = Meeting.find id
    MeetingPresenter.new(meeting: meeting)
  end

  def assign_params(params)
    mp = MeetingPresenter.meeting_params(params)
    self.meeting.assign_attributes(mp)
  end

  def save
    # Deffered association save, since ActiveRecord lacks
    self.meeting.updated_at_will_change!
    self.meeting.singleton_class.before_save do
      # NB. in this block 'self' refers to the meeting being saved
    end
    self.meeting.save
  end

  private

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
