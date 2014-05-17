
require 'shelljs/make'

mission = require 'mission'

target.rsync = ->
  mission.rsync
    file: './'
    dest: 'tiye:~/server/blog/'
    options:
      exclude: [
        'node_modules/'
      ]