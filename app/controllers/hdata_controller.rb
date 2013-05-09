class HdataController < ApplicationController

  before_filter :set_up_section
  before_filter :extract_payloads, :if => ->(c) { c.request.put? || c.request.post? }
  before_filter :audit_log
  before_filter :find_record

  protected

  def set_up_section
    @section_name = params[:section] || controller_name
    sr = SectionRegistry.instance
    @extension = sr.extension_from_path(params[:section])
    render text: 'Section Not Found', status: 404 unless @extension
  end

  def import_document(content_type, doc=nil)
    document = doc || request.body.read
    importer = @extension.importers[content_type]
    input = (content_type == 'application/xml') ? Nokogiri::XML(document) : document
    importer.import(input)
  end

  def extract_payloads

    if request.content_type == "multipart/form-data"
      @document = import_document(params[:content].content_type, params[:content])
      input = Nokogiri::XML(params[:metadata].read)
      result = HealthDataStandards::Import::Hdata::MetadataImporter.instance.import(input)
      @document.document_metadata = result
    else
      @document = import_document(request.content_type)
    end

  end

  def audit_log
    return if current_user.nil?
    event = "#{controller_name}_#{action_name}"
    desc = ""
    desc = "record_id:#{params[:record_id]}" if params[:record_id]
    desc += "|section:#{params[:section]}" if params[:section]
    desc += "|id:#{params[:id]}" if params[:id]
    AuditLog.create(requester_info: current_user.email, event: event, description: desc)
  end

end