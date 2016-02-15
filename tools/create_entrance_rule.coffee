#
# エントランスの回転方向作成ツール
#
# 使い方 # coffee create_entrance_rule.coffee
# ひとまず手動でルールデータに追加
#

fs = require 'fs'
https = require 'https'

# geojsonを取得
getJSON = (url, cb)->
  https.get url, (req, res)->
    data = ''

    req.on 'data', (chunk)->
      data += chunk

    req.on 'end', ->
      # 名大4Fのエラー対策
      try
        cb JSON.parse data
      catch e
        console.error 'error: ' + e.message
        cb null

# フロアのbbox, angleを取得
createFloor = (floorid, cb)->
  getJSON "https://app.haika.io/api/facility/3/#{floorid}.geojson", (geojson)->
    if geojson == null
      cb {
        id: floorid
        bbox: null
        angle: null
      }
    else
      cb {
        id: floorid
        bbox: geojson.bbox
        angle: geojson.properties.floor.angle
      }

# 施設内のすべてのフロアからbbox, angleを取得
createFacility = (facilityid)->
  facility = []
  getJSON "https://app.haika.io/api/facility/#{facilityid}/", (json)->
    # 名大4Fのデータのエラー対策
    ids = Object.keys(json.floors)

    floorid = ids.shift()
    recursion = ->
      createFloor floorid, (floor)->
        facility.push floor
        if ids.length > 0
          floorid = ids.shift()
          recursion()
        else
          fs.writeFile "facility#{facilityid}.json", JSON.stringify facility, null, 2
          console.log "施設#{facilityid}読み込み完了"
    recursion()

createFacility '3' # 名古屋大学図書館
createFacility '7' # 鯖江市図書館
