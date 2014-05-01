
{renderer} = require 'cirru-html'

express = require 'express'
fs = require 'fs'
path = require 'path'
mime = require 'mime'
marked = require 'marked'

marked.setOptions
  gfm: yes
  breaks: yes

NodeCache = require 'node-cache'
pages = new NodeCache stdTTL: 100, checkperiod: 120


app = express()

indexFile = 'cirru/index.cirru'
indexCode = fs.readFileSync indexFile, 'utf8'
indexPage = renderer indexCode, '@filename': indexFile

app.get '/', (req, res) ->
  res.send indexPage()

postFile = 'cirru/post.cirru'
postCode = fs.readFileSync postFile, 'utf8'
postPage = renderer postCode, '@filename': postFile

app.get '/posts/:year/:month/:name', (req, res) ->
  p = req.params
  name = decodeURIComponent p.name
  file = path.join 'posts', p.year, p.month, name

  res.writeHeader 200, 'content-type': 'text/html'

  pages.get file, (err, item) ->

    if item[file]?
      res.end item[file]
      return

    fs.readFile file, 'utf8', (err, content) ->
      html = postPage
        title: name
        content: marked content
      res.end html
      pages.set file, html

app.get '/css/:file', (req, res) ->
  file = path.join 'css', req.params.file

  pages.get file, (err, item) ->
    if item[file]?
      res.writeHeader 200, 'content-type': 'text/css'
      res.end item[file]
      return
    res.sendfile file
    fs.readFile file, 'utf8', (err, content) ->
      pages.set file, content

port = process.env.PORT or 3000
app.listen port
console.log 'Running blog at:', port
