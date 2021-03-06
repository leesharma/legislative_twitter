# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  bill_id           :integer
#  title             :string
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#
class Attachment < ActiveRecord::Base
  VALID_FILETYPES = %w(image/jpg image/jpeg image/png application/pdf)

  belongs_to :bill, touch: true
  has_attached_file :file

  validates_attachment :file,
                       presence:      true,
                       size:          { less_than: 1.megabytes },
                       content_type:  { content_type: VALID_FILETYPES }
end
