class C32Controller < ApplicationController
  before_filter :find_record, only: [:index, :show]

  respond_to :xml, :json, :atom
  
  def index
    audit_log "c32_index"
    respond_to do |wants|
      wants.atom {}
    end
  end

  
  def show
    desc = audit_log "c32_access"
    AuditLog.doc("NONE", "c32_access", desc, @record, @record.version)

    respond_with(@record)
  end
  
end
