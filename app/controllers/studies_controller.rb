class StudiesController < ApplicationController

  before_filter :find_record

  respond_to :atom, :html

  def index
    @studies = @record.studies
  end

end