load = ->
  script = document.createElement('script')
  script.onload = ->
    initializeApp()

    # アプリアドオンの読み込み
    addon = document.createElement('script')
    addon.onload = ->
      information.install()
    addon.src = 'js/information_all.js'
    document.body.appendChild addon

    style = document.createElement('link')
    style.rel = 'stylesheet'
    style.type = 'text/css'
    style.href = 'css/information.css'
    document.head.appendChild style

  $.ajax
    type: 'GET'
    url: 'https://calil.jp/static/apps/sabatomap/update_v120.js'
    cache: false
    dataType: 'script'
    timeout: 5000
    success: (data) ->
      script.innerHTML = data
      document.body.appendChild script
    error: ->
      script.src = 'js/all.js'
      document.body.appendChild script
if cordova?
  document.addEventListener 'deviceready', load
else
  load()