# == Schema Information
#
# Table name: motions
#
#  id         :integer          not null, primary key
#  meeting_id :integer
#  bill_id    :integer
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Motion < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :bill

  has_many :roll_calls,         dependent: :destroy
  has_many :votes,              through: :roll_calls
  accepts_nested_attributes_for :roll_calls,
                                reject_if: ->(attr) { attr[:type].blank? },
                                allow_destroy: true

  has_many :sponsorships, dependent:  :destroy
  has_many :sponsors,     through:    :sponsorships,
                          source:     :person

  def sponsors_list
    if sponsors.empty?
      'no recorded sponsors'
    else
      sponsors.collect(&:name).join(', ')
    end
  end
end
