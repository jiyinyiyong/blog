
fs = require 'fs'
show = console.log

file = fs.readFileSync 'a.text', 'utf8'
arr = file.split '\n\n'
show arr.length

page = arr.map (line) ->
  line = line.replace /(http(s)?:\S+)/g, "<a href='$1'>$1</a>"
  "<p>#{line}</p>"
fs.writeFile 'weibo.html', page.join('')