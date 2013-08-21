class ImagesController < ApplicationController
  include OAuth2::TokenAuthorizable
  
  before_filter :find_record, :find_study

  respond_to :atom, :html

  def index
    @images = @study.images
  end

  def show
    @image = @study.images.where(id: params[:image_id]).first
    if params[:format] == 'jpg'
      send_data @image.jpeg, :type => 'image/jpg',:disposition => 'inline'
    elsif params[:format] == 'dcm'
      send_data @image.data, :type => 'application/dicom',:disposition => 'inline'
    end
  end

  private

  def find_study
    @study = @record.studies.where(id: params[:study_id]).first
  end

end
