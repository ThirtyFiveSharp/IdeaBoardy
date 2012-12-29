class ApiController < ApplicationController
  include RepresentationBuilder
  include ShortenUrl

  def get_embeddable(entity_class)
    (params[:embed] || "").split(',').collect { |s| s.strip.to_sym }.select { |s| embeddable?(entity_class.new, s) }
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

  def api_board_url(id)
    get_shorten_url("api_board", id)
  end

  private
  def get_representation_builder(obj)
    "#{obj.to_s.underscore.singularize}_representation"
  end
end