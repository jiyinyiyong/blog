#!/usr/bin/coffee

# this command named /usr/local/bin/liuxian

title = ''

make_array = (arr) ->
  scope_lines = []

  for line in arr
    last_index = scope_lines.length - 1
    if line[0] is '@'
      title = line[1..].trim()
      scope_lines.push "<p class='title'>#{title}</p>"
    else if last_index < 0
      scope_lines.push line.trimRight()
    else
      empty_line = line.match /^\s*$/
      if empty_line?
        if (typeof scope_lines[last_index]) is 'object'
          scope_lines[last_index].push ''
        else scope_lines.push ''
      else
        code_line = line.match /^\s\s.+$/
        if code_line?
          if (typeof scope_lines[last_index]) is 'object'
            scope_lines[last_index].push line[2..]
          else scope_lines.push [line[2..]]
        else scope_lines.push line

  output_array = []
  for item in scope_lines
    if (typeof item) is 'object'
      stack = []
      while item[-1..-1][0] is ''
        stack.push '&nbsp;'
        item.pop()
      output_array.push (make_array item)
      output_array.push space for space in stack
    else output_array.push item

  output_array

mark_line = (line) ->
  line.replace(/>/g,'&gt;')
    .replace(/</g,'&lt')
    .replace(/\t/g,'&nbsp;')
    .replace(/\s/g, '&nbsp;')

comment_line = (line) ->
  line = line.replace(/`([^`]*[^\\`]+)`/g, '<code class="inline_code">$1</code>')
    .replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>')
    .replace(/#(.*[^\\])#/g, '<b>$1</b>')

make_html = (arr) ->
  html = ""
  for line in arr
    if typeof line is 'object'
      html += "<div class='code_block'>#{make_html line}</div>"
    else
      if line is '' then line = '&nbsp;'
      line = mark_line line
      html += "<p class='code_line'>#{line}</p>"
  html

make_page = (arr) ->
  content = "<title>#{title}</title><a id='home' href='../index.html'>Home</a>"
  content+= '<link rel="stylesheet" href="../style.css">'
  for line in arr
    if typeof line is 'object'
      content += "<div class='code_block'>#{make_html line}</code></div>"
    else
      if line is '' then line = '&nbsp;'
      line = comment_line line
      content += "<p>#{line}</p>"
  content

# console.log make_page (make_array (data.split '\n'))

render = (str) ->
  arr = str.split '\n'
  make_page (make_array arr)

fs = require 'fs'

file = process.argv[2]
match = file.split '.'

disqus =
  """   <div id="disqus_thread"></div>
        <script type="text/javascript">
            /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
            var disqus_shortname = 'jiyinyiyong'; // required: replace example with your forum shortname

            /* * * DON'T EDIT BELOW THIS LINE * * */
            (function() {
                var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
                dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
                (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
            })();
        </script>
        <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
        <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
        """

fs.readFile file, 'utf-8', (err, data) ->
  fs.writeFile match[0]+'.html', (render data) + disqus