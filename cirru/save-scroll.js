
var saveScrollTop = 0;
try {
  saveScrollTop = localStorage.getItem('saveScrollTop')
  saveScrollTop = Number(saveScrollTop)
} catch (err) {
  console.log("nothing");
}
var list = document.querySelector('#list')
list.scrollTop = saveScrollTop
list.addEventListener('scroll', function() {
  saveScrollTop = list.scrollTop
})

window.onbeforeunload = function() {
  localStorage.setItem('saveScrollTop', saveScrollTop)
}
