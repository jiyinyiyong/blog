
require 'shelljs/make'

mission = require 'mission'

target.rsync = ->
  mission.rsync
    file: './'
    options:
      dest: 'tiye:~/server/blog/'
      exclude: [
        'node_modules/'
      ]