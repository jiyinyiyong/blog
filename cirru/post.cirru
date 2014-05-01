doctype

html
  head
    title $ @ title
    meta (:charset utf-8)
    link (:rel stylesheet) $ :href /css/page.css
  body
    .home
      a
        :href /
        = Home
    div
      :class article
      @ content

    @insert disqus.html