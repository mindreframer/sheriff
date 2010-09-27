class RestController < ApplicationController
  respond_to :html, :xml, :json
  inherit_resources
  include InheritedResources::DSL

  protected

  def resource
    @resource ||= super
  end

  def build_resource
    @resource ||= super
  end

  def collection
    @collection ||= resource_class.paginate(:per_page => 20, :page => params[:page], :order => params[:order].presence)
  end
end