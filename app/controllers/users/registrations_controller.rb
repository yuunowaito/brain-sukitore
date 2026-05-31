# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ImageProcessable

  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  def new
    build_resource({})
    resource.build_profile
    respond_with resource
  end

  # GET /resource/edit
  def edit
    super
    resource.profile || resource.build_profile
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def destroy_avatar
    current_user.profile.avatar.purge
    redirect_to edit_user_registration_path, notice: "プロフィール画像を削除しました"
  end

  def update
    super do |resource|
      if resource.errors.empty? && params[:user][:profile_attributes][:avatar].present?
        begin
          processed = process_and_transform_image(
            params[:user][:profile_attributes][:avatar], 200
          )
          resource.profile.avatar.attach(processed)
        rescue ImageProcessable::ImageProcessingError => e
          flash.now[:alert] = e.message
          render :edit, status: :unprocessable_content and return
        end
      end
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ profile_attributes: [ :name ] ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ profile_attributes: [ :name, :id, :avatar ] ])
  end
end
