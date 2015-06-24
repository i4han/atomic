

collections = ->
   Users:
      publish: -> @Matches = db.Users.find gender: 'F', public_ids: {$exists: true}, location: $near: 
         $geometry: type: "Point", coordinates: [ -118.3096648, 34.0655627 ] 
         $maxDistance: 20000
         $minDistance: 0
      callback: -> 
         window.Matches = db.Users.find({}).fetch()
         @UserReady()
      collections:
         "fs.files":
            publish:  -> @Files = db["fs.files"].find _id: $in: @Matches.fetch().reduce ((o, a) -> o.concat a.photo_ids), []
            callback: -> @Files = db['fs.files'].find({}).fetch()                            
            collections:
               "fs.chunks":
                  publish:  -> db["fs.chunks"].find files_id: $in: @Files.fetch().map (a) -> a._id
                  callback: -> @Chunks = db['fs.chunks'].find({}).fetch()

exports.Parts = ->
   title:        (_, v) -> blaze.Include _, 'contentFor', headerTitle: '', html.H1 _, class: 'title', v
   $header1:     (t) -> HEADER @, _bar: '* *-nav', _: H1 @, _title: _: t
   $header2:     (t) -> DIV @, _bar: '* *-header *-light', _: H1 @, class: 'title', t
   $class:       (v) -> DIV @, class: v
   $id:          (v) -> DIV @, id: v
   $header:      (v) -> 
      blaze.include @, 'contentFor', headerTitle: '', H1 @, class: 'title', v.title
      #v.left  and blaze.include @, 'contentFor', headerButtonLeft:  '', v.left
      #v.right and blaze.include @, 'contentFor', headerButtonRight: '', v.right 
   $content:     (v) -> DIV @, class: 'content', _: v
   $btnBlock:    (v) -> _button: '* *-block', id: v
   $mp:          (v) -> margin: v, padding: v
   $tabItem:     (v) -> class: 'tab-item', href: v, dataIgnore: 'push'
   $box:         (a) -> width: a[0], height: a[1]
   $padded:      (v) -> DIV @, class: 'content', DIV @, class: 'content-padded', v
   $subfooter:   (v) -> _bar: '* *-standard *-footer-secondary', _: v
   $fixedTop:    (v) -> position: 'fixed', top: v
   $fixedBottom: (v) -> position: 'fixed', bottom: v
   $photoCard:   (v) -> background: 'white', borderRadius: 2, padding: v or '8px 6px', boxShadow: '1px 1px 5px 1px'

exports.Modules = ->
   width  = 375
   height = 667
   box    = width / 5
   top    = 22
   bottom = 44
   swipe  = 22
   pic_top    = top + box
   pic_height = height - (pic_top + bottom)

   layout: ->
      template: ->
         ionic.Body @, 
            ionic.NavBar  @, class: 'bar-royal' 
            ionic.NavView @, blaze.Include @, 'yield'
            blaze.Include @, 'tabs'
      head: -> [
         html.META  @, name:'viewport', content:'width=device-width initial-scale=1.0, user-scalable=no'
         html.TITLE @, Settings.title ]

   tabs:    
      template: -> 
         ionic.Tabs      @, _tabs: '*-icon-top', 
            blaze.Each   @, 'tabs', =>
               ionic.Tab @, title: '{label}', path: '{name}', iconOff: '{icon}', iconOn: '{icon}'
      helpers: 
         tabs: -> 'chat camera spark settings profile'.split(' ').map (a) -> Modules[a]

   profile: ->
      icon: 'person', path: 'profile'         
      template: -> [
         part.title    @, 'Profile'
         ionic.Content @, 
            ionic.List @, class: 'profile', 
               blaze.Each    @, 'items', =>
                  ionic.Item @, buttonRight: true,
                     html.H2 @, 'title {title} content &#123; &#125; {content} works!'
                     html.P  @, cube.viewLookup @, 'content'
                     html.BUTTON   @, _button: '* *-positive', 
                        ionic.Icon @, icon: 'ios-telephone'
         ionic.SubfooterBar @, 
            html.BUTTON     @, $btnBlock: 'facebook', 'login with facebook' ]
      style: b0: bottom: 70
      helpers:
         items: -> [
            {title:'hello', content:'world'}
            {title:'hello1', content:'world1'}
            {title:'hello2', content:'world2'}
            {title:'hello3', content:'world3'}
         ] 
         token: -> facebookConnectPlugin.getAccessToken ((token) -> Session.set 'fbToken', token), (->)
      events: 'touchend #facebook': -> # api(graphPath, permissions, s, f) getLoginStatus logEvent name, params, valueToSum logPurchase logout showDialog options
         facebookConnectPlugin.login ['publish_actions'], (-> 
            facebookConnectPlugin.getAccessToken ((token) -> 
               Session.set 'fbToken', token
            ), (e) -> console.log 'Token fail', e
            facebookConnectPlugin.api 'me', ['public_profile'], ((data) ->
               Session.set 'fbProfile', data
            ), (e) -> console.log 'API fail', e
            facebookConnectPlugin.getLoginStatus ((data) ->
               console.log data
            ), (e) -> console.log 'Login Status fail', e
         ), (e) -> 
            console.log 'Login fail', e
            facebookConnectPlugin.api 'me', ['public_profile'], ((data) ->
               console.log 'fb Profile get', data
               Session.set 'fbProfile', data
            ), (e) -> console.log 'API fail', e
            facebookConnectPlugin.getLoginStatus ((data) ->
               console.log data
            ), (e) -> console.log 'Login Status fail', e
      _onRendered: ->
         $.ajaxSetup cache: true
         $.getScript '//connect.facebook.net/en_US/sdk.js', ->
            FB.init appId: '839822572732286', version: 'v2.3'
            FB.getLoginStatus (d) -> console.log 'FB login', d

   settings: 
      icon: 'gear-a', path: 'settings'
      template: -> [ 
         part.title @, 'Settings'
         ionic.View @, 
            ionic.Content   @, 
               html.P       @, 'hello world!'
         ionic.SubfooterBar @, 
            html.BUTTON     @, $btnBlock: 'logout', 'logout'
      ]
      events: 
         'touchend #logout': -> facebookConnectPlugin.logout (->
            Router.go 'profile'
         ), ((e) -> console.log 'logout error', e)

   chat:
      icon: 'chatbubbles', path: 'chat'
      template: -> [
         part.title  @, 'Chat'
         html.DIV    @, class: 'content', 
            html.DIV @, class: 'content-padded',
               blaze.Each   @, 'chats', =>
                  html.DIV  @, id: '{id}', _chat: '* *-{side}', '{text}'
         ionic.SubfooterBar @, html.INPUT @, id: 'chat-input0', type: 'text' ]
      style:
         _contentPadded: $fixedBottom: bottom * 2
         _chat:     display: 'block'
         _chatMe:   color: 'black'
         _chatYou:  marginLeft: 20
         _chatRead: color: 'grey' 
         input0:    $fixedBottom: bottom, $box: ['100%', bottom], $mp:0, border: 0
      helpers: chats: -> db.Chats.find {}
      events: ->
         'keypress _[#input0]': (e) =>
            if e.keyCode == 13 and text = (Jinput = $(@Id '#input0')).val()
               Jinput.val ''
               Meteor.call 'says', 'isaac', text
      methods: says: (id, text) -> db.Chats.insert id: id, text: text
      collections: Chats: {}

   spark: ->
      @Matches = []
      icon_index = 0
      setImage = (id, i) -> Session.set 'img-photo-id', Matches[i].public_ids[0]
      pass   = (J) -> J.animate top: '+=1000', 600, -> J.remove()
      choose = (J) -> J.animate top: top, width: box, left: box * icon_index++, clip: 'rect(0px, 75px, 75px, 0px)', 500, -> J.switchClass 'photo-touched', 'icon', 300
      
      push   = (i) =>
         loaded = true
         Jfront = $('#photo-' + i)
         photo = Settings.image_url + Matches[i].public_ids[0]
         Jfront
            .switchClass 'photo-back', 'photo-front', 0, -> $('#photo-' + (i + 1)).css left: 0
            .after HTML.toHTML html.IMG @, id:'photo-' + (i + 1), _photo: '* *-back', src: photo + '.jpg'
            .draggable axis: 'y'
            .on 'touchstart', (e) -> Jfront.switchClass 'photo-front', 'photo-touched', 100
            .on 'touchend',   (e) -> switch
               when e.target.y > pic_top + swipe then push(i + 1) and pass   Jfront
               when e.target.y < pic_top - swipe then push(i + 1) and choose Jfront
               else Jfront.switchClass 'photo-touched', 'photo-front', 100, ->  Jfront.animate top: pic_top, 100

      icon: 'flash', path: '/'
      template: -> [
         part.title  @, 'Spark'
         html.DIV    @, class: 'content', 
            html.IMG @, _photo: '* *-back', id: 'photo-0', src: 'spark0.jpg']
      style:
         _photo:        $fixedTop: pic_top, width: width, background: 'white', overflow: 'hidden'
         _icon:         zIndex:  20, width: box, top: top, clip: 'rect(0px, 75px, 75px, 0px)'
         _photoFront:   zIndex:  10, top: pic_top  
         _photoBack:    zIndex: -10, left: width
         _photoTouched: zIndex:  30, width: width - 1, $photoCard: ''
      collections: -> collections.call @
      fn: UserReady: -> push(0)

   camera: ->
      uploadPhoto = (uri) ->
         (ft = new FileTransfer()).upload uri, Settings.upload, ((r) -> console.log 'ok', r
         ), ((r) -> console.log 'err', r
         ), x.assign options = new FileUploadOptions(), o =
            fileKey:  'file'
            fileName: uri[uri.lastIndexOf('/') + 1..]
            mimeType: 'image/jpeg'
            chunkedMode: true
            params: id: 'isaac'             #ft.onprogress (r) -> console.log r
      upload = (url) -> 
         resolveLocalFileSystemURL url, ((entry) ->
            entry.file ((data) -> console.log('data', data) or uploadPhoto l = data.localURL), (e) -> console.log e
         ), (e) -> console.log 'resolve err', e

      icon: 'camera', path: 'camera'
      template: -> [
         part.title @, 'Camera'
         html.IMG   @, id: 'camera-photo', style: 'width:100%;' ]         
      onRendered: -> 
         navigator.camera.getPicture ((uri) -> upload(uri)), (->), options =
            quality: 90
            cameraDirection: Camera.Direction.FRONT
            destinationType: Camera.DestinationType.FILE_URI
            encodingType:    Camera.EncodingType.JPEG           
            sourceType:      Camera.PictureSourceType.CAMERA #PHOTOLIBRARY #saveToPhotoAlbum: false #allowEdit: true <- doesn't work. 

      onServer: ->
         fs     = Npm.require 'fs'
         Busboy = x.require 'busboy'
         cloud  = x.require 'cloudinary'
         _ = Settings.cloudinary
         cloud.config cloud_name: _.cloud_name, api_key: _.api_key, api_secret: _.api_secret
         Router.onBeforeAction (req, res, next) ->
            filenames = []
            if req.url is '/upload' and req.method is 'POST'
               busboy = new Busboy headers: req.headers
               busboy.on('file', (field, file, filename) ->
                     console.log 'param', req
                     file.pipe cloud.uploader.upload_stream (r) -> console.log 'stream', r, req.body.id
                     filenames.push filename)
               busboy.on 'finish', -> 
                  req.filenames = filenames
                  next()
               busboy.on 'field', (field, value) -> req.body[field] = value
               req.pipe busboy
            else next()
         Router.route('/upload', where: 'server').post ->
            @response.writeHead 200, 'Content-Type': 'text/plain'
            @response.end "ok"
 
   chosenbox:
      template: -> 
         html.DIV @, _chosen: '*-container', id: "chosen-{id}", style:"left:{left}px;", 
            html.IMG @, id: "chosen-box-{id}"
      style: _chosenContainer: $fixedTop: top, $box: [box, box], zIndex: 200,  border: 3, overflowY: 'hidden'

   chosen:
      template: -> 
         html.DIV @, id: 'chosen', 
            blaze.Each @, chosen: blaze.Include @, 'chosenbox'
      helpers: chosen: [0..4].map (i) -> id: i, left: box * i



exports.Settings = ->
   local_ip = '192.168.1.78'
   deploy_domain = 'spark5.meteor.com'

   app:
      info:
         id: 'com.spark.game'
         name: 'Spark game'
         description: 'Spark game long name.'
         website: 'http://sparkgame.com'
      icons:
         iphone:    'resources/icons/icon-60x60.png'
         iphone_2x: 'resources/icons/icon-60x60@2x.png'
      setPreference:
         BackgroundColor: '0xff0000ff'
         HideKeyboardFormAccessoryBar: true
      configurePlugin:
         'com.phonegap.plugins.facebookconnect':
            APP_NAME: 'spark-game-test'
            APP_ID:  process.env.FACEBOOK_CLIENT_ID
            API_KEY: process.env.FACEBOOK_SECRET
      accessRule: [
         "http://localhost/*"
         "http://meteor.local/*"
         "http://#{local_ip}/*"
         "http://connect.facebook.net/*"
         "http://*.facebook.com/*"
         "https://*.facebook.com/*"
         "ws://#{local_ip}/*"
         "http://#{deploy_domain}/*"
         "ws://#{deploy_domain}/*"
         "http://res.cloudinary.com/*"
         "mongodb://ds031922.mongolab.com/*"]
   deploy:
      name: 'spark5' #sparkgame spark[1-5]
      mobileServer: 'http://spark5.meteor.com'

   title: -> @app.info.name
   theme: "clean"
   lib:   "ui"
   env:
      production:
         MONGO_URL: process.env.MONGO_URL
   npm:
      busboy:     "0.2.9"
      cloudinary: "1.2.1"
   public: 
      collections: {}
      image_url: "http://res.cloudinary.com/sparks/image/upload/"
      upload: "http://#{local_ip}:3000/upload"
   cloudinary:
      cloud_name: "sparks"
      api_key:    process.env.CLOUDINARY_API_KEY
      api_secret: process.env.CLOUDINARY_API_SECRET
   facebook:
      oauth:
         version: 'v2.3'
         url: "https://www.facebook.com/dialog/oauth"
         options:
            query:
               client_id: process.env.FACEBOOK_CLIENT_ID 
               redirect_uri: 'http://localhost:3000/home'
         secret:    process.env.FACEBOOK_SECRET 
         client_id: process.env.FACEBOOK_CLIENT_ID 

#