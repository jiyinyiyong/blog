#!/usr/bin/coffee
# this command named /usr/local/bin/liuxian

title = ''
add_title = (str) ->
  title = str[1..].trim()
  "<pre class='title'>#{title}</pre>"

list = (a) -> Array.isArray a

code_array = (arr) ->
  arr

make_array = (arr) ->
  lines = []

  for line in arr
    tail = lines.length - 1
    if line[0] is '@' then lines.push (add_title line)
    else if line.trim().length is 0
      if list lines[tail] then lines[tail].push ''
      else lines.push ''
    else if line[0..1] is '  '
      if (list lines[tail]) then lines[tail].push line[2..]
      else lines.push [line[2..]]
    else lines.push line.trimRight()

  output = []
  for item in lines
    if list item
      stack = []
      while item[-1..-1][0] is ''
        stack.push ' '
        item.pop()
      output.push (make_array item)
      output.push space for space in stack
    else output.push item
  output

mark_line = (line) ->
  line.replace(/>/g,'&gt;')
    .replace(/</g,'&lt')
    .replace(/\t/g,' ')
    .replace(/\s/g, ' ')

comment_line = (line) ->
  line = line
    .replace(/#([^`]*[^\\])#/g, '<b>$1</b>')
    .replace(/`([^`]*[^\\`]+)`/g, '<code class="inline_code">$1</code>')
    .replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>')

make_html = (arr) ->
  html = ""
  for line in arr
    if list line
      html += "<div class='code_block'>#{make_html line}</div>"
    else
      if line is '' then line = ' '
      line = mark_line line
      html += "<pre>#{line}</pre>"
  html

disqus = """
  <div id="disqus_thread"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'jiyinyiyong';
        // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script');
            dsq.type = 'text/javascript';
            dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            if (document.getElementsByTagName('head')[0]) {
              document.getElementsByTagName('body')[0].appendChild(dsq);
            }
        })();
    </script>
    <noscript>
      Please enable JavaScript to view the
      <a href="http://disqus.com/?ref_noscript">
        comments powered by Disqus.
      </a>
    </noscript>
    <a href="http://disqus.com" class="dsq-brlink">
      comments powered by
      <span class="logo-disqus">
        Disqus
      </span>
    </a>
  </div>
  """

make_page = (arr) ->
  content = "<a id='home' href='../index.html'>Home</a>"
  content+= '<link rel="stylesheet" href="../style.css">'
  for line in arr
    if typeof line is 'object'
      content += "<pre class='code_block'>#{make_html line}</code></pre>"
    else
      if line is '' then line = ' '
      line = comment_line line
      content += "<pre>#{line}</pre>"
  "<title>#{title}</title><meta charset='utf-8'>
  <div id='article'>#{content}#{disqus}</div>"

# console.log make_page (make_array (data.split '\n'))

render = (str) ->
  arr = str.split '\n'
  make_page (make_array arr)

fs = require 'fs'

file = process.argv[2]
match = file.split '.'

fs.readFile file, 'utf-8', (err, data) ->
  fs.writeFile "../posts/#{match[0]}.html", (render data)
  console.log match[0]+'.html'