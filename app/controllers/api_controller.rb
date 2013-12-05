class ApiController < ApplicationController
  include RepresentationBuilder
  include ShortenUrl

  def default_url_options
    api_protocol = ENV['RAILS_API_PROTOCOL']
    api_host = ENV['RAILS_API_HOST']
    api_port = ENV['RAILS_API_PORT']

    options = {}
    options[:protocol] = api_protocol unless api_protocol.nil?
    options[:host] = api_host unless api_host.nil?
    options[:port] = api_port unless api_port.nil?
    options
  end

  def get_embeddable(entity_class)
    (params[:embed] || '').split(',').collect { |s| s.strip.to_sym }.select { |s| embeddable?(entity_class.new, s) }
  end

  def embeddable?(entity, name)
    representation_builder = get_representation_builder(entity.class)
    entity.respond_to?(name) and respond_to?(representation_builder)
  end

  def build_representation(entity, embeddable = [])
    representation_builder = get_representation_builder(entity.class)
    representation = send(representation_builder, entity)
    embed_resources(embeddable, representation, entity)
  end

  def embed_resources(resources_to_embed, representation, entity)
    resources_to_embed.each do |resource|
      representation_builder = get_representation_builder(resource)
      representation[resource] = entity.send(resource).collect do |embedded_entity|
        send(representation_builder, embedded_entity)
      end if embeddable?(entity, resource)
    end
    representation
  end

  private
  def get_representation_builder(obj)
    "#{obj.to_s.underscore.singularize}_representation"
  end
end