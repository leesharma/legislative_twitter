# == Schema Information
#
# Table name: meetings
#
#  id               :integer          not null, primary key
#  organization_id  :integer
#  date_and_time    :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  agenda_approved  :boolean
#  minutes_approved :boolean
#  location         :string
#
class Meeting < ActiveRecord::Base
  # Model Variables
  DEFAULT_LOCATION = 'Suite 5, 433 River Street, Troy, NY 12180'
  PROCEDURE =   'Pursuant to Section 2.72-2 entitled "Public Forum" of the '\
                'Special Rules of Order of the Troy City Council a period of '\
                'time shall be designated during each regular or special '\
                'meeting of the City Council as a public forum during which '\
                'citizens of the City shall be permitted to address the Council '\
                'on legislation on that meeting\'s agenda and on any subject '\
                'appropriate to the conduct ofTroy City government. Length of '\
                'time allotted for citizen comment shall be no longer than '\
                'five (5) minutes per speaker. At the completion of the agenda, '\
                'citizen\'s comment shall be no longer than five (5) minutes per '\
                'speaker appropriate to any subject to the conduct of Troy '\
                'City government.'

  belongs_to :organization

  has_many :meeting_items, dependent: :destroy
  accepts_nested_attributes_for :meeting_items,
                                reject_if: ->(attr) { attr[:title].blank? && attr[:text].blank? },
                                allow_destroy: true

  has_many :attendances, dependent: :destroy
  has_many :people, through: :attendances

  has_many :motions, dependent: :destroy
  has_many :bills, through: :motions
  accepts_nested_attributes_for :motions,
                                allow_destroy: true

  # Scopes
  scope :upcoming, -> { where('date_and_time > ?', Time.zone.now) }

  # Validations
  validates :organization,  presence: true
  validates :date_and_time, presence: true

  # Aliases
  alias_attribute :'approved_agenda?', :agenda_approved
  alias_attribute :'approved_minutes?', :minutes_approved
  alias_attribute :date, :date_and_time

  # INSTANCE METHODS
  # Returns array of grouped bill
  def grouped_bills
    bills.uniq.sort_by(&:created_at).group_by(&:type)
  end

  def grouped_motions
    motions.sort_by { |f| f.bill.created_at }.group_by { |f| f.bill.type }
  end

  # Returns calculated name of meeting of the form:
  #   <Organization> Meeting on <date>
  def name
    organization.name + ' Meeting on ' + date.to_formatted_s(:long_ordinal)
  end

  # Returns string for default value for datetimepicker, formatted correctly.
  # Defaults to two weeks from now if no date is set.
  def datetimepicker_value
    (date_and_time ? date_and_time : DateTime.current.advance(weeks: 2))
      .strftime('%Y/%m/%d %R')
  end

  # Status Methods
  def happened?
    date_and_time <= Time.zone.now
  end
  alias_method :started?, :happened?

  def toggle_approval(document)
    case document
    when :agenda
      self.agenda_approved = !agenda_approved
    when :minutes
      self.minutes_approved = !minutes_approved
    end
    self.save!
  end
end
