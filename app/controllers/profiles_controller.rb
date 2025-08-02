class ProfilesController < ApplicationController
  before_action :set_profile, only: [:index, :upload_avatar]

  def index
    @profile_avatar_url = @profile.avatar_url
  end

  def upload_avatar
    begin
      @profile.avatar.attach(avatar_params[:avatar])

      if @profile.valid_for_avatar_upload?
        @profile.save!(validate: false) # Skip validation when saving
        render json: {
          success: true,
          message: 'Avatar uploaded successfully',
          avatar_url: @profile.avatar_url
        }
      else
        render json: {
          success: false,
          error: @profile.errors[:avatar].join(', ')
        }
      end
    rescue => e
      render json: {
        success: false,
        error: "Upload failed: #{e.message}"
      }
    end
  end

  private

  def set_profile
    # For now, we'll use the first profile or create one if none exists
    @profile = Profile.first
    unless @profile
      @profile = Profile.create!(
        name: 'Palak Paliwal',
        email: 'palakpaliwal@gmail.com'
      )
    end
  end

  def avatar_params
    params.require(:profile).permit(:avatar)
  end
end
