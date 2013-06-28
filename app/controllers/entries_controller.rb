require "oauth2/token_introspection"

class EntriesController < HdataController
  include OAuth2::TokenAuthorizable

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :check_oauth2_authorization

  respond_to :html
  respond_to :atom, only: [:index]
  respond_to :json, :xml, except: [:index, :delete]

  def index
    @entries = @record.send(@section_name)
    fresh_when(last_modified: @entries.max(:updated_at))
    respond_with(@entries)
  end
  
  def show
    ## TODO need to auditlog the actual record content
    if stale?(last_modified: @entry.updated_at, etag: @entry)
      respond_to do |wants|
        wants.json {render :json => @entry.attributes}
        wants.xml do
          exporter = @extension.exporters['application/xml']
          render :xml => exporter.export(@entry)
        end
      end
    end
  end

  def create
    @record.send(@section_name).push(@document)
    response['Location'] = section_document_url(record_id: @record, section: @section_name, id: @document)
    render text: 'Section document created', status: 201
  end
  
  def update
    @entry.update_attributes!(@document.attributes)
    @entry.reflect_on_all_associations(:embeds_many).each do |relation|
      @entry.send(relation.name).destroy_all
      @entry.send("#{relation.name}=", @document.send(relation.name))
    end
    
    render text: 'Document updated', status: 200
  end

  def delete
    @entry.destroy
    render nothing: true, status: 204
  end
  
end
