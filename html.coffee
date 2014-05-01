
log = console.log
fs = require "fs"
path = require "path"
disqus = require("./src/disqus").disqus
marked = require "marked"
hljs = require "highlight.js"

marked.setOptions
  gfm: yes
  breaks: yes
  highlight: (code, lang) ->
    hljs.highlightAuto(code).value

filename = process.argv[2]
post_dir = "./posts/"

names = filename.split("/")[1..]
target = path.join post_dir, names.join("").replace /md$/, "html"

result = title + meta + style + home + body + disqus + analytics

fs.writeFileSync target, result