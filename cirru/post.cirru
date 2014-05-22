
doctype

html
  head
    title $ @ title
    meta $ :charset utf-8
    link (:rel icon) $ :href http://tiye.qiniudn.com/tiye.jpg
    link (:rel stylesheet) $ :href /css/page.css
  body
    #home $ a (:href /) $ = "Back to list"
    #article
      #markdown $ @ content
      a#note (:target _blank)
        :href http://weibo.com/jiyinyiyong
        = "这里不方便留言," 请到微博上联系
    @insert ga.html