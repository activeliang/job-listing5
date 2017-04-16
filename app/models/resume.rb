class Resume < ApplicationRecord
  belongs_to :job
  belongs_to :user
  validates :content,presence: true
  mount_uploader :attachment, AttachmentUploader
end
