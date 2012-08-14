
$ ->
  p = $('#paint')

  paint = (array) ->
    p.empty()
    for item in array
      p.append '<div></div>'
      a = p.children().last()
      a.css 'width', "#{(item * 10)}px"

  arr = []
  for item in [1..30]
    n = Math.floor (Math.random() * 100)
    arr.push n

  paint arr

  delay = (t, f) ->
    console.log 'aaa'
    setTimeout f, t

  sort = (arr, end, cursor) ->
    if cursor is end
      if end is 0 then 'end'
      else delay 10, -> sort arr, (end - 1), 0
    else
      if arr[cursor] > arr[cursor+1]
        [arr[cursor], arr[cursor+1]] = [arr[cursor+1], arr[cursor]]
      paint arr
      delay 10, -> sort arr, end, (cursor + 1)

  len = arr.length
  sort arr, len, 0