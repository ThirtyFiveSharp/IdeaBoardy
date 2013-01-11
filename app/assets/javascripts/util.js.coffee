Array::getLink = (rel) ->
  link = _.find(this, (link) -> link.rel is rel)
  link || {rel: null, href: null}