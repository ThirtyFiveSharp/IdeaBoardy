module RepresentationBuilder
  def board_representation(board)
    {
        id: board.id,
        name: board.name,
        description: board.description,
        shortenUrlCode: get_shorten_url("api_board", board.id),
        links: [
            {rel: :self, href: api_board_url(board.id)},
            {rel: :sections, href: api_board_sections_url(board.id)},
            {rel: :concepts, href: api_board_concepts_url(board.id)},
            {rel: :tagcloud, href: api_board_tagcloud_index_url(board.id)},
            {rel: :tags, href: api_board_tags_url(board.id)},
            {rel: :invitation, href: api_emails_invitation_url},
            {rel: :share, href: api_emails_share_url}
        ]
    }
  end

  def section_representation(section)
    {
        id: section.id,
        name: section.name,
        color: section.color,
        links: [
            {rel: :self, href: api_section_url(section.id)},
            {rel: :ideas, href: api_section_ideas_url(section.id)},
            {rel: :immigration, href: immigration_api_section_url(section.id)}
        ]
    }
  end

  def idea_representation(idea)
    {
        id: idea.id,
        content: idea.content,
        vote: idea.vote,
        tags: idea.tags.collect { |tag| tag_representation(tag) },
        links: [
            {rel: :self, href: api_idea_url(idea.id)},
            {rel: :vote, href: vote_api_idea_url(idea.id)},
            {rel: :merging, href: merging_api_idea_url(idea.id)},
            {rel: :tags, href: api_idea_tags_url(idea.id)}
        ]
    }
  end

  def tag_representation(tag)
    resource_links = [{rel: :self, href: api_tag_url(tag.id)}]
    resource_links << {rel: :concept, href: api_concept_url(tag.concept.id)} unless tag.concept.nil?
    {
        id: tag.id,
        name: tag.name,
        links: resource_links
    }
  end

  def concept_representation(concept)
    {
        id: concept.id,
        name: concept.name,
        links: [
            {rel: :self, href: api_concept_url(concept.id)},
            {rel: :tags, href: api_concept_tags_url(concept.id)}
        ]
    }
  end
end