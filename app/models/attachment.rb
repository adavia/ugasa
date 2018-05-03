class Attachment < ApplicationRecord
  belongs_to :attacheable, polymorphic: true, optional: true
  validate :avatar_size_validation

  mount_uploader :file, AttachmentUploader

  private

  def avatar_size_validation
    errors[:file] << "should be less than 10MB" if file.size > 10.megabytes
  end
end
