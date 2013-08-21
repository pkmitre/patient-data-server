require "oauth2/token_introspection"

class StudiesController < ApplicationController
  include OAuth2::TokenAuthorizable
  before_filter :find_record

  respond_to :atom, :html

  def index
    @studies = @record.studies
  end

end
