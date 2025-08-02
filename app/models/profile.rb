class Profile < ApplicationRecord
  has_one_attached :avatar

  validates :name, presence: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validate :avatar_validation, if: -> { avatar.attached? }

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
    else
      '/assets/download.jpeg' # fallback image
    end
  end

  def valid_for_avatar_upload?
    # Only validate avatar-specific rules
    avatar_validation
    errors[:avatar].empty?
  end

  private

  def avatar_validation
    if avatar.attached?
      # Check file type
      unless avatar.content_type.in?(['image/jpeg', 'image/png', 'image/gif', 'image/webp'])
        errors.add(:avatar, 'must be a JPEG, PNG, GIF, or WebP image')
      end

      # Check file size (5MB limit)
      if avatar.byte_size > 5.megabytes
        errors.add(:avatar, 'must be less than 5MB')
      end
    end
  end
end
