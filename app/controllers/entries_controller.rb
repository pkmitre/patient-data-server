class EntriesController < HdataController
  before_filter :audit_log
  before_filter :find_entry, except: [:index, :create]

  skip_before_filter :verify_authenticity_token

  respond_to :html
  respond_to :atom, only: [:index]
  respond_to :json, :xml, except: [:index, :delete]


  def index
    @entries = @record.send(@section_name)
    respond_with(@entries)
  end
  
  def show
    ## TODO need to auditlog the actual record content

    respond_to do |wants|
      wants.json {render :json => @entry.attributes}
      wants.xml do
        exporter = @extension.exporters['application/xml']
        render :xml => exporter.export(@entry)
      end
      wants.html { }
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

  private

  def find_entry
    @entry = @record.send(@section_name).where(id: params[:id]).first if Moped::BSON::ObjectId.legal?(params[:id])
    not_found unless @entry
  end

end
