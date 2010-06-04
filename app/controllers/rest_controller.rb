class RestController < ApplicationController
  inherit_resources
  include InheritedResources::DSL

  show! do |success|
    success.html{render :action=>:edit}
  end

  protected

  def resource
    @resource ||= super
  end

  def build_resource
    @resource ||= super
  end

  def collection
    @collection ||= resource_class.paginate(:per_page => 20, :page => params[:page])
  end
end