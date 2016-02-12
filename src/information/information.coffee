###
  インフォメーション表示機能

  Copyright (c) 2016 CALIL Inc.
  This software is released under the MIT License.
  http://opensource.org/licenses/mit-license.php
###

class Information
  view: null
  lastMinor: null

  constructor: ->
    # pass

  install: =>
    # View(react)の初期化
    element = document.createElement 'div'
    element.id = 'information_box'

    reactElement = React.createElement InformationView
    @view = ReactDOM.render reactElement, element
    document.getElementById('map').insertBefore element, null

  updateResult: (minor)=>
    $.ajax
      dataType: 'html'
      url: "https://calil.jp/warabi/nu/bunrui.php?minor=" + minor + '&new=' + 1
      cache: false
      crossDomain: true
    .done (data)->
      if latestNearestInformationMinor is minor
        @view.setProps result: data
    .fail (e)->
      console.error e

information = new Information()

# 周辺の情報を表示
latestNearestInformationMinor = null
loadNearestInformation = (minor, success)->
  latestNearestInformationMinor = minor
  $.ajax
    dataType: 'html'
    url: "https://calil.jp/warabi/nu/bunrui.php?minor=" + minor + '&new=' + 1
    cache: false
    crossDomain: true
  .done (data)->
    if latestNearestInformationMinor is minor
      console.log 'loadNearestInformation ' + latestNearestInformationMinor
      $("#nu-info").html data
      $("#nu-info").show()
      if success isnt null
        success()
  .fail ->
    $("#nu-info").html '<div>データがありません</div>'
    $("#nu-info").show()

# 周辺の情報を探す
waitNearestInformationTimer = null
waitNearestInformation = (success)->
  start = new Date()
  cancel = ->
    clearInterval waitNearestInformationTimer
    waitNearestInformationTimer = null
  onTimer = ->
    if kanikama.currentPosition isnt null
      # 名大用なので今は'nearest1'のみ考慮
      switch kanikama.currentPosition.algorithm
        when 'nearest1'
          loadNearestInformation kanikama.currentPosition.beacon.minor, success
          cancel()
          return
    # 10秒以上で終了
    if new Date() - start >= 10 * 1000
      cancel()

  if waitNearestInformationTimer is null
    waitNearestInformationTimer = setInterval onTimer, 1000
    onTimer()

# 周辺の情報を探すのテストコード
testWaitNearestInformation = ->
  waitNearestInformation -> console.log 'success'
  kanikama.push [
    {uuid: "00000000-71C7-1001-B000-001C4D532518", major: 105, minor: 70, rssi: -100}
  ]
