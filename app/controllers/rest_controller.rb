class RestController < ApplicationController
  respond_to :html, :xml, :json
  inherit_resources
  include InheritedResources::DSL

  show! do |success|
    success.html{render :action=>:edit}
  end

  # standard respond_to :html, :xml, :json does not seem to work, roll our own...
  def self.hacky_respond_to(*args)
    options = args.extract_options!.delete(:options) rescue nil
    index! do |success|
      if @collection and @collection.respond_to?("to_#{params[:format]}")
        success.xml{ render :text => @collection.to_xml(options) }
        success.json{ render :text => @collection.to_json(options) }
      end
    end
  end

  protected

  def resource
    @resource ||= super
  end

  def build_resource
    @resource ||= super
  end

  def collection
    @collection ||= resource_class.paginate(:per_page => 20, :page => params[:page], :order => params[:order].presence, :conditions => params[:conditions].presence)
  end
end