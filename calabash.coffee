
require('calabash').do 'dev',
  'pkill -f doodle'
  'jade -o ./ -wP layout/index.jade'
  'stylus -o src/ -w layout/'
  'doodle src/ index.html'