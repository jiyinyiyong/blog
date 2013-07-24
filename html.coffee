
log = console.log
fs = require "fs"
path = require "path"
disqus = require("./src/disqus").disqus
marked = require "marked"
hljs = require "highlight.js"

marked.setOptions
  gfm: yes
  breaks: yes
  highlight: (code, lang) -> hljs.highlightAuto(code).value

filename = process.argv[2]
post_dir = "./posts/"

names = filename.split("/")[1..]
target = path.join post_dir, names.join("").replace /md$/, "html"

meta = "<meta charset='utf-8'>"
content = fs.readFileSync filename, "utf8"
body = "<div class='article'>#{marked content}</div>"

title = "<title>#{names.join ""}</title>"
style = "<link rel='stylesheet' href='../src/page.css' />" +
  "<link rel='stylesheet'
  href='http://softwaremaniacs.org/media/soft/highlight/styles/github.css'>"
doodle = "<script src='http://dev:7777/doodle.js'></script>"
home = "<div class='home'><a href='../index.html '>Home</a></div>"
analytics = """
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-41753901-1', 'jiyinyiyong.github.io');
  ga('send', 'pageview');
</script>
"""
result = title + meta + style + home + body + disqus + analytics

fs.writeFileSync target, result