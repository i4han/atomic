
fym = 'YYYYMM'
date_box_size = 120
calendar_size = date_box_size * 7 + 14
fullsize   = -> width: '100%', height: '100%'
fullscreen = (zIndex) -> position: 'fixed', top: 0, left: 0, zIndex: zIndex
bigButton  = (color)  -> backgroundColor: color, borderWidth: 2, borderColor: color, height: 50, width: 210, fontSize: 20

exports.index =
index:
    head: ->[
        "script(type='text/javascript' src='<%= @googlemap_input %>')"
        "meta(name='viewport', content='initial-scale=1.0, user-scalable=no')"
        "meta(charset='utf-8')"]
    eco: -> googlemap_input: -> x.urlWithQuery Settings.google.map_input    
logo:
    block: 'navbar', jade: li: i0: 'Getber'
    absurd: i0: height: 50, width: 110, float: 'left', padding: 15, fontWeight: 200, fontSize: 15, color: 'white', textAlign: 'center'
layout:
    block: 'window',   jade: ['+navbar', $wrapper: ['+sidebar', '+yield']]
    absurd: body: backgroundColor: '#ddd'
    navbar: sidebar: true, login: true, menu: 'home map calendar request log help'
layout_naked: block: 'window', jade: '+yield'
logo_main:
    block: 'main', jade: _logo_left0:'get', _logo_right0:'ber'
    absurd:
        _logo: marginTop:   60, fontSize: 32, color: 'white', padding: 2, display: 'inline'
        left0:  marginLeft: 80, backgroundColor: 'blue'
        right0: marginLeft:  0, backgroundColor: 'green'
copy_main:
    block: 'main', jade: hero0:
        copy0:    'Safeguard your family rides'
        _copy_i1:   'For parents'
        _copy_i2:  ['+button(label="Connect with UBER" id="{%connect0}")', '+br(height="2")']
        _copy_i3:   'For 18 years or younger'
        _copy_i4:  ['+button(label="Sign up for Teens" id="{%signup0}")']
    events: 'click %connect0': -> Router.go '/forward/uber_oauth'
    absurd:
        hero0: width: 700, paddingBottom: 20, backgroundColor: 'rgba(255,255,255,0.15)'
        copy0: 
            marginTop:  40, marginLeft: 80,  textAlign:  'left', 
            fontSize:   48, color: 'white',  textShadow: '1px 1px 3px #000'
        _copy: 
            marginLeft: 80, textAlign: 'left', 
            fontSize:   32, color: 'white',  textShadow: '1px 1px 5px #000'
        connect0: bigButton('blue')
        signup0:  bigButton('green')
    function:
        id: (id) -> '#hello-world-' + id
main:
    block: 'window', router: path: '/', layoutTemplate: 'layout_naked'
    jade:  'bg0 screen0 video0 +logo_main +copy_main'.split ' '
    absurd: ->
        bg0:          [fullscreen(-100), fullsize(), backgroundColor: '#333']
        screen0:      [fullscreen(-10),  fullsize(), @Settings.screen_bg]
        video0:        height: 50
        '#bg-video':  [fullscreen(-100), height: '100.0%', marginLeft: 0, display: 'block']
    onStartup: -> window.movie = x.style '#bg-video'
    on$Ready:  -> $(window).resize -> x.windowFit style: movie, selector: $video, ratio: 1.78
    onRendered: ->
        #video = VIDEO id:'bg-video', preload:'auto', autoplay:true, loop:'loop', muted:'muted', volume:'0', src:'uber.mp4', SOURCE src:'uber.mp4', type:'video/mp4'
        
        video = """<video id="bg-video" preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" src="/uber.mp4">
                       <source src="/uber.mp4" type="video/mp4">
                   </video>"""
        window.$video = $(video).insertAfter @id 'video0'
        x.timeout 100, -> $(window).resize()
home: 
    block: 'content', sidebar: 'sidebar_home',  router: {}  
    jade: $contentWrapper: 
            h2_title0:  'Sign up with UBER'
            p_name0:    'Isaac'
            p_address0: 'Home'
            '+button(label="Connect with UBER" id="{%connect0}")': ''                    
            _colMd$6:   'See you soon{{hello}}'
            _colMd$11_pack0: 'each items': ['+item']
    eco: -> oauth: -> x.oauth 'uber'
    methods: 
        hello: (name) -> 'Hello ' + name + '!'
        uber_oauth: -> x.oauth 'uber'
    helpers: 
        items: -> db.Items.find {}, sort: created_time: -1
        hello: -> Session.get 'hello'
    events: 'click %connect0': -> Router.go '/forward/uber_oauth'
    absurd: 
        _item: backgroundColor:'white', width:240, float:'left', margin:6
        pack0: width: '100%'
        title0:   width:500 
        name0:    width:200 
        address0: width:400
    onCreated: ->
        Meteor.call 'hello', 'world', (e, result) -> Session.set 'hello', result
        Meteor.call 'uber_oauth',     (e, result) -> Session.set 'uber_oauth', result
    onRendered: ->
        id = @id 'pack0' 
        x.timeout 40, -> $(id).masonry itemSelector: '.item', columnWidth: 126
        @id('title0 name0 address0').map (i) -> $(i).editable()

sidebar_home: x.sidebar ['home', 'calendar', 'help']
world: jade: h1: '{{a}} world'
history:
    label: 'Ride History', router: {}
    HTML: """
    <a class="twitter-timeline" href="https://twitter.com/hashtag/calgary" data-widget-id="589270954393489408">#calgary Tweets</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    """
location: router: {}, jade: 'location'
profile:
    sidebar: 'sidebar_profile', router: {}
    jade: $contentWrapper: 'with user': ['| {{name}}', '| {{phone}}']
    helpers:
        user: -> name: 'Isaac Han', phone: 'xxx-xxxx'
        access_token: -> 1
item: jade: ".item(style='height:{{height}}px;color:{{color}}')" 
submit:
    router: {}
    jade: 
        h2:'Connected'
        '+button(label="Add rider" id="{%add0}")': ''
        p: 'access_token is {{token}} {{output}}'
    helpers:
        token: -> x.hash().access_token
        output: -> JSON.stringify Session.get('uber_profile'), null, 4
    onCreated: -> call.uber_profile token:x.hash().access_token
    absurd: 
        add0: backgroundColor: 'green', borderWidth: 2, borderColor: 'green', height: 30, width: 150, fontSize: 12
    events: 'click %add0': -> console.log 'add rider'
__vehicle:
    label: 'Vehicle', sidebar: 'sidebar_vehicle', router: path: 'vehicle'
    jade: $contentWrapper: 
            h1: 'You vehicle information', br: ''
            _colSm$7: 'each items': ['+form', 'br'] 
    helpers: items: -> [
            { label: 'Maker', id: 'maker', title: 'Car manufacturer',      icon: 'mobile' },
            { label: 'Model', id: 'model', title: 'Year of the model',     icon: 'mobile' },
            { label: 'Color', id: 'color', title: 'Color of your vehicle', icon: 'mobile' }]
    events: x.popover 'maker model color' .split ' '
popover_maker: jade: ul:li: 'manufacturer in 20 characters'
popover_model: jade: ul:li: 'For digit'
popover_color: jade: ul:li: 'White or black only'
sidebar_vehicle: x.sidebar 'home map calendar request vehicle log help'.split ' '             

map: 
    sidebar: 'sidebar_map', router: {}, jade: $mapCanvas: ''
    absurd: $mapCanvas: height: '100%', padding: 0, margin: 0
    onRendered: ->
        google.maps.event.addDomListener window, 'load', Module.map.map_init
        x.timeout 10, Module.map.map_init
    map_init: -> 
        new google.maps.Map document.getElementById('map-canvas'), 
            disableDefaultUI: true, zoom: 11, center: lat: 53.52, lng: -113.5
sidebar_map: x.sidebar 'home map calendar request log help'.split ' '             
            
calendar:
    router: {}
    jade: $contentWrapper:
            $containerCalendar: _scrollspy_top0: '&nbsp;', items0: '', _scrollspy_bottom0: '&nbsp;'
    onRendered: -> 
        [top, bottom, items] = @id 'top0 bottom0 items0'
        x.calendar fym, this_month = moment().format fym, items, top, bottom
        $(top).data id:this_month
        x.scrollSpy enter:
            top:    -> x.calendar moment($(top   ).data('id'), fym).subtract(1, 'month').format fym
            bottom: -> x.calendar moment($(bottom).data('id'), fym).add(     1, 'month').format fym
    styl:
        $containerCalendar: width: calendar_size, maxWidth: calendar_size
        h2: color:'black', display:'block' 
        _everyday: position: 'relative', width:date_box_size, height:date_box_size, float:'left', padding:8, backgroundColor:'white', margin:2           
        _month:    display:'block', height: calendar_size
        _spacer:   lineHeight: 10
log:
    router: {}
    jade:  log0: ''
    onRendered: -> $(@id 'log0').html "<object id=#{@id('screen0')[1..]} data=http://localhost:8778//>"
    absurd:
        log0:  height: '100%', width: '100%'
        screen0: height: '100%', width: '100%'
policy: router: {}, jade: h2:'Privacy Policy'
uber:   router: {}, jade: h2:'Uber'
redirect: router: {}, jade: h2:'redirect'
day:
    collection: 'calendar'
    jade: -> 'init title date day event'.split(' ').map((c) -> ".#{c} {{#{c}}}").join '\n'
    helpers:
        date:  -> moment(@id, 'YYYYMMDD').format 'D'
        day:   -> moment(@id, 'YYYYMMDD').format 'ddd'
        title: -> db.Calendar.findOne({id:@id})?['title'] or 'Title'
        event: -> ''
        init:  ->
            x.position parentId:@id, class:'title', top:14,
            x.position parentId:@id, class:'event', top:45,
            x.position parentId:@id, class:'date',  top: 5, left:(date_box_size - 35)
            x.position parentId:@id, class:'day',   top:28, left:(date_box_size - 37)
            ''
    absurd:
        _init:  display:'none'
        _title: display:'inline', fontWeight:'100'               
        _date:  display:'inline', fontWeight:'600', fontSize:'14pt', width:24, textAlign:'right'
        _day:   display:'table',  fontWeight:'100', float:'right',   width:24, textAlign:'right', color:'#444',  fontSize: '8pt'
        _event: resize:'none',    fontWeight:'100'
        '.row#day01': marginBottom:0
gmap:
    jade: [ 
        'input(id="pac-input", class="controls", type="text", placeholder="Enter a location")'
        '#map-canvas']
    onRendered: -> 
        google.maps.event.addDomListener window, 'load'
        x.timeout 10, -> x.gmapInit 
            disableDefaultUI: true, mapTypeId: "roadmap", zoom: 11, center: lat: 53.52, lng: -113.5

request:
    router: {}
    jade: '#contentWrapper': 
            h1: 'Request', br: ''
            _colSm$9_e11: 'each items': ['+form', 'br']
            _colSm$9_e12: ['input(type="tel",id="mobile-number",class="form-control")', 'br']
            _colSm$9_e13: ['+gmap']
    styl: e13: height: 300
    helpers: items: -> [
            { label: 'Phone',   id: 'phone',     title: 'Phone Number',    icon: 'mobile'   }
            { label: 'Date',    id: 'datepicker',title: 'Pick your date',  icon: 'calendar' }
            { label: 'Name',    id: 'name',      title: 'Your name',  icon: 'user'     }
        ]
    __helpers: items: -> [ 'label, id, title, icon'
        'Name    |name    |Your name          |user'
        'Phone   |phone   |Phone Number       |mobile'
        'Address |address |Your home Zip code |envelope' ]
    events: x.popover 'name phone address' .split ' '
    onRendered: -> 
        $('#datepicker').css("opacity", '50%').datepicker()
        datepicker = document.querySelector '#datepicker'
        datepicker.addEventListener 'focus', ->
            datepicker.removeEventListener 'focus'
            x.timeout 100, -> $('.ui-datepicker-header').removeClass 'ui-corner-all ui-widget-header'
        x.timeout 100, -> $('#mobile-number').intlTelInput 
            preferredCountries: ["ca", "us"]
            utilsScript: "/utils.js"
        $('#ui-datepicker-div').removeClass('ui-corner-all')
popover_name:    jade: ul: ['li Write your name.', 'li No longer then 12 letters.']
popover_phone:   jade: ul: li:'Write your phone number.'
popover_address: jade: ul: li:'Write your zipcode.'

help: 
    router: {} 
    jade: '#contentWrapper': h1:'style', pre:'{{output}}'
    helpers: output: -> ([0..(sheets = document.styleSheets).length].map (i) ->
        sheets[i]? and (rules = sheets[i].cssRules)? and ([0..rules.length].map (j) ->
            rules[j]? and "#{i}:#{j}\n" + rules[j].cssText).join '\n').join '\n'          

