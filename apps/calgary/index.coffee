

fullsize   = -> width: '100%', height: '100%'
fullscreen = (zIndex) -> position: 'fixed', top: 0, left: 0, zIndex: zIndex
bigButton  = (color)  -> backgroundColor: color, borderWidth: 2, borderColor: color, height: 50, width: 210, fontSize: 20
widget_id = ['592037597326610433', '592037985006190592', '592038136508649472', '592038331401113600', '592038497021612032', '592038669051006976', '592038775259148291', '592038880963989504', '592040098918633472', '592040195505041408',
             '592040339747147776', '592040484647763968', '592040609797378048', '592040736729604096', '592040875204546562', '592040970507591680', '592041067551166464', '592041181657178113', '592041307712819202', '592095299209826306',
             '592095536359964672', '592095824693170176', '592095931647963137', '592096105573191680', '592096544460902400', '592098504505315329', '592098601666392064', '592098703013388288', '592098801491410944', '592098902834159617',
             '592098990222512128', '592099242128248832', '592099326618308608', '592099410697289728', '592099582147842048',
             '592358731561603072', '592358961698906112', '592359090375921664', '592359443020447744', '592359535437742080', '592359622385602563']

exports.index =

logo:
    block: 'navbar', jade: li: i0: 'Watchman'
    absurd: i0: height: 50, width: 110, float: 'left', padding: 15, fontWeight: 200, fontSize: 15, color: 'white', textAlign: 'center'
layout:
    head: -> [
            "script(type='text/javascript' src='<%= @googlemaps %>')"
            "script(type='text/javascript' src='/jquery.flot.min.js')"
            "script(type='text/javascript' src='/jquery.flot.time.min.js')"
            "meta(name='viewport', content='initial-scale=1.0, user-scalable=no')"
            "meta(charset='utf-8')"]
    eco: -> googlemaps: -> x.urlWithQuery Settings.google.maps

    block: 'window',   jade: ['+navbar', $wrapper: ['+sidebar', '+yield', '+twitter_widget']]
    absurd: body: backgroundColor: '#ddd'
    navbar: sidebar: true, login: true, menu: 'home map calendar request log help'
layout_naked: block: 'window', jade: '+yield'
logo_main:
    block: 'main', jade: _logo_left0:'Watchman'
    absurd:
        _logo: marginTop:   60, fontSize: 32, color: 'white', padding: 2, display: 'inline'
        left0:  marginLeft: 80, backgroundColor: 'blue'
        right0: marginLeft:  0, backgroundColor: 'green'
copy_main:
    block: 'main', 
    jade: 
        hero0:
            copy0:    'Construction Site Watchman'
            _copy_i1:   'For Calgary citizen'
            _copy_i2:  ['+button(label="Watch" id="{%connect0}")', '+br(height="2")']
        _calgarylogo: 'img(src="/calgary_logo.jpg" width="120")': ''

    events: 'click %connect0': -> 
        $('#bg-video').css 'display', 'none'
        $('#bg-video').html('')
        Router.go '/view/:kml_25'
    absurd:
        _calgarylogo: width: 140, marginTop: 160, padding: 10, background: 'white', margin: '0 auto'
        hero0: width: 700, paddingBottom: 20, marginLeft: 60, marginBottom: 100, backgroundColor: 'rgba(255,255,255,0.15)'
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
    jade:  'bg0 screen0 video0 +copy_main'.split ' '
    absurd: ->
        bg0:          [fullscreen(-100), fullsize(), backgroundColor: '#333']
        screen0:      [fullscreen(-10),  fullsize(), @Settings.screen_bg]
        video0:        height: 50
        '#bg-video':  [fullscreen(-100), height: '100.0%', marginLeft: 0, display: 'block']
    onStartup: -> window.movie = x.style '#bg-video'
    on$Ready:  -> 
        $(window).resize -> 
            $('#twitter-widget-0') and $('#twitter-widget-0').height($(window).height() - 50)
            $video and x.windowFit style: movie, selector: $video, ratio: 1.78
    onRendered: ->
        #video = VIDEO id:'bg-video', preload:'auto', autoplay:true, loop:'loop', muted:'muted', volume:'0', src:'uber.mp4', SOURCE src:'uber.mp4', type:'video/mp4'
        
        video = """<video id="bg-video" preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" src="/Calgary_tour.mp4">
                       <source src="/Calgary_tour.mp4" type="video/mp4">
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
twitter_widget:
    HTML: """
    <div id="twitter-wrapper"></div>    
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    """
    onRendered: ->
        id = Session.get('pid') or 1  
        widget = widget_id[Number(id) - 1]
        $('#twitter-wrapper').html("""
            <a class="twitter-timeline" href="https://twitter.com/hashtag/watchman#{id}" data-widget-id="#{widget}">#watchman#{id} Tweets</a>""")


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
        '+button(label="Add rider" id="{%add0}")':''
        p:'access_token is {{token}} {{output}}'
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

graph:
    HTML: """
        <div id="content" class="col-lg-12 col-sm-12">
            <div class="row">
                <div class="col-lg-6 col-sm-6 col-xs-6 col-xxs-12 nopadding">
                    <div class="col-sm-12" style="padding-left: 0px; padding-right: 0px">
                        <div class="panel panel-default">
                          <div class="panel-heading">
                            <h3 class="panel-title">Air Quality</h3>
                          </div>
                          <div class="panel-body">
                              <div id="realtimechart" style="height:190px;"></div>
                          </div>
                        </div>
                    </div><!--/col-->
                </div><!--/col-->
                <div class="col-lg-6 col-sm-6 col-xs-6 col-xxs-12 nopadding">
                    <div class="col-sm-12" style="padding-left: 0px; padding-right: 0px">
                        <div class="panel panel-default">
                          <div class="panel-heading">
                            <h3 class="panel-title">Noise Level</h3>
                          </div>
                          <div class="panel-body">
                              <div id="realtimechart2" style="height:190px;"></div>
                          </div>
                        </div>
                    </div><!--/col-->
                </div><!--/col-->
            </div><!--/row-->
        </div><!--/container-->
        """
    absurd: ->
        _nopadding: paddingRight: 0, paddingLeft: 0
    onRendered: ->
        data = []
        data2 = []
        totalPoints = 300
        getRandomData = ->
            if data.length > 0
                data = data.slice(1)
                # do a random walk
            while data.length < totalPoints
              prev = if data.length > 0 then data[data.length - 1] else 50
              y = prev + Math.random() * 10 - 5
              if y < 0
                y = 0
              if y > 100
                y = 100
              data.push y
            # zip the generated y values with the x values
            res = []
            i = 0
            while i < data.length
              res.push [
                i
                data[i]
              ]
              ++i
            res
        
        getRandomData2 = ->
            if data.length > 0
              data2 = data2.slice(1)
            # do a random walk
            while data2.length < totalPoints
              prev = if data2.length > 0 then data2[data2.length - 1] else 50
              y = prev + Math.random() * 10 - 5
              if y < 0
                y = 0
              if y > 100
                y = 100
              data2.push y
            # zip the generated y values with the x values
            res = []
            i = 0
            while i < data2.length
              res.push [
                i
                data2[i]
              ]
              ++i
            res

          # setup control widget
        updateInterval = 300

        update = ->
            plot.setData [ getRandomData() ]
            # since the axes don't change, we don't need to call plot.setupGrid()
            plot.draw()
            setTimeout update, updateInterval
            return

        update2 = ->
            plot2.setData [ getRandomData2() ]
            # since the axes don't change, we don't need to call plot.setupGrid()
            plot2.draw()
            setTimeout update2, updateInterval
            return

        if $('#realtimechart').length
            options = 
              series: shadowSize: 1
              lines:
                fill: true
                fillColor: colors: [
                  { opacity: 1 }
                  { opacity: 0.1 }
                ]
              yaxis:
                min: 0
                max: 100
              xaxis: show: false
              colors: [ '#72CAED' ]
              grid:
                tickColor: '#dddddd'
                borderWidth: 0
            plot = $.plot($('#realtimechart'), [ getRandomData() ], options)
            update()
        if $('#realtimechart2').length
            options2 = 
              series: shadowSize: 1
              lines:
                fill: true
                fillColor: colors: [
                  { opacity: 1 }
                  { opacity: 0.1 }
                ]
              yaxis:
                min: 0
                max: 100
              xaxis: show: false
              colors: [ '#F4A506' ]
              grid:
                tickColor: '#dddddd'
                borderWidth: 0
            plot2 = $.plot($('#realtimechart2'), [ getRandomData() ], options2)
            update2()

view: 
    router: path: '/view/:id', data: -> 
        Session.set 'pid', @params.id[5..]
    jade: '#contentWrapper': 
        $mapCanvas: ''
        '.graph': '+graph': ''
    absurd: 
        $mapCanvas: height: 300, padding: 0, margin: 0
        _graph: margin: 20
    onRendered: ->
        google.maps.event.addDomListener window, 'load', Module.view.map_init
        #x.timeout 10, Module.view.map_init
        #id and console.log db.ConstructionSite.find({id: id[1..]}).fetch()
    map_init: -> 
        new google.maps.Map document.getElementById('map-canvas'), 
            disableDefaultUI: true, zoom: 12, center: lat: 51.0505819, lng: -114.0786754     
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

side_menu_list:
    jade: li: 
        'a(href="{{path}}" id="kml_{{id}}" class="cc")': ['.id {{id}}', '| {{{name}}}', 'br'
            '| start: {{started}}', 'br', '| end: {{ended}}'
            'hr', '{{description}}']
    helpers:
        path: -> '/view/:' + @id 
        id: -> 
            Session.set @id + ':coordinates', @coordinates
            pid = ''
            if (pid = Session.get 'pid') == @id[4..] 
                $('#site-title').html(@name)
                if !$('#twitter-wrapper').hasClass('open')
                    1
                    #$("#wrapper").toggleClass "twitter"
                    #$("#twitter-wrapper").toggleClass "open"
                widget = widget_id[Number(pid) - 1]
                #$('#twitter-wrapper').html("""
                #    <a class="twitter-timeline" href="https://twitter.com/hashtag/watchman#{pid}" data-widget-id="#{widget}">#watchman#{pid} Tweets</a>""")
                google.maps.event.addDomListener window, 'load', Module.side_menu_list.function.map_init(@id)
                x.timeout 30, -> Module.side_menu_list.function.map_init(id)
            # console.log 'coordinates', pid, @id, @coordinates
            @id[4..]
        name: -> 
            name = @name
            [['Avenue', 'Ave'], ['Street', 'St'], ['Road', 'Rd'], ['Drive', 'Dr'], ['Trail', 'Tr'], ['Boulevard', 'Blvd']].map (a) ->
                name = name.replace new RegExp("\\s+#{a[0]}\\s+", "mg"), ' ' + a[1] + ' '
            'between and at'.split(' ').map (i) -> name = name.replace new RegExp("\\s+#{i}\\s+", "mg"), "<br>#{i}<br>"
            name
        started: -> moment(@started, 'YYYYMMDDHHSS').format('llll')
        ended:   -> moment(@ended,   'YYYYMMDDHHSS').format('llll')
    events: ->
        'click .cc': (event) -> 
            id = event.toElement.id
            Session.set 'id', Number(id[4..])
            google.maps.event.addDomListener window, 'load', Module.side_menu_list.function.map_init(id)
            pid = id[4..]
            widget = widget_id[Number(pid) - 1]
            $('#realtimechart').css 'display','none'
            $('#realtimechart2').css 'display','none'
            x.timeout 5000, ->
                $('#realtimechart').css 'display','block'
                $('#realtimechart2').css 'display','block'
            #$('#twitter-wrapper').html("""
            #    <a class="twitter-timeline" href="https://twitter.com/hashtag/watchman#{pid}" data-widget-id="#{widget}">#watchman#{pid} Tweets</a>""")
            x.timeout 30, -> Module.side_menu_list.function.map_init(id)
    function:
        map_init: (id) ->
            console.log 'map_init', id, Session.get(id + ':coordinates')
            [lng, lat] = Session.get(id + ':coordinates').split ','
            LatLng = new google.maps.LatLng Number(lat)+ 0.02, Number(lng)
            map = new google.maps.Map document.getElementById('map-canvas'), {zoom: 14, center: LatLng}
            marker = new google.maps.Marker position: LatLng, map: map, title: 'Hello World!'


    absurd:
        '.sidebar-nav li a':
            display: 'block', position: 'relative', textDecoration: 'none', color: 'grey', background: 'white', lineHeight: 18, textIndent: 0
            margin: '18px 18px 18px 18px', padding: 10, borderRadius: 3, boxShadow: '1px 1px 3px 3px rgba(190,190,190,1)'
        '.id': 
            position: 'absolute', zIndex:5000, right: 10, top: -4, width: 30, height: 20
            background: 'rgba(200, 0, 0, 0.8)', color: 'white', textAlign: 'center'

menu_list:
    jade: li:'a(href="{{path}}" id="{{id}}")': '{{label}}'
    helpers: 
        path:  -> Router.path @name 
        label: -> Module[@name].label
        
navbar:                                    # seperate menu_list and navbar
    jade: ->
        """
        .navbar.navbar-default.navbar-#{@Theme.navbar.style}
            .navbar-left 
                ul.nav.navbar-nav
                    li: a#menu-toggle: i.fa.fa-bars
                    +logo
                    li: #space &nbsp;
                    li: #site-title
            .navbar-right
                ul.nav.navbar-nav
                    li: a#twitter-toggle: i.fa.fa-twitter
        """
    styl: ->
        '.navbar': backgroundColor:@Theme.navbar.backgroundColor
        '.navbar-fixed-top': border: 0
    events:
        'click #twitter-toggle': (event) -> 
            $("#wrapper").toggleClass "twitter"
            $("#twitter-wrapper").toggleClass "open"
        'click #menu-toggle': (event) -> $("#wrapper").toggleClass "menu" # event.preventDefault()                
        'click #navbar-menu': (event) ->
            menu_selected = event.target.innerText.toLowerCase()
            $('#listen-to-menu-change').trigger 'custom', [menu_selected]

    styl$: ->
        T = @Theme.navbar 
        '#space': width: 100, padding: 15
        '#menu-toggle': width: 50
        '#twitter-toggle': width: 50, marginRight: 13, textAligh: 'center'
        '#login-buttons': 
            height: 50, width: T.login.width, textAligh: 'center'
            padding: 15
        'li#login-dropdown-list': 
            width: T.login.width, height: T.height, display: 'table-cell'
            textAlign: 'center', verticalAlign: 'middle'
        '.navbar-default .navbar-nav > li > a:focus': backgroundColor: T.focus.backgroundColor
        '#site-title': 
            color: T.text.color, padding: 15, marginLeft: 5, fontSize: 14
        '.navbar-default .navbar-nav > li > a': color: T.text.color
        '.navbar-left > ul > li > a': width: T.text.width, textAlign: 'center'
        '.navbar-right > ul > li:hover, .navbar-left > ul > li:hover, .navbar-nav > li > a:hover':
            textDecoration: 'none', color: T.hover.color, backgroundColor: T.hover.backgroundColor
        '.dropdown-toggle > i.fa-chevron-down': paddingLeft: 4
        '#navbar-menu:focus': color: 'black', backgroundColor: T.focus.backgroundColor
        '#twitter-toggle:focus': color: 'black', backgroundColor: T.focus.backgroundColor
sidebar: 
    absurd: -> 
        sidebar_width = 260
        twitter_width = 300
        '#wrapper': 
            paddingTop: 50, paddingLeft: 0, paddingRight: 0, marginRight: 0, WebkitTransition: 'all 0.8s ease', 
            '@media(min-width:768px)': paddingLeft: sidebar_width, height: '100%'
            #-webkit-transition: all 0.5s ease;
            #-moz-transition: all 0.5s ease;
            #-o-transition: all 0.5s ease;  
        '#wrapper.menu': paddingLeft: sidebar_width, '@media(min-width:768px)': paddingLeft: 0
        '#wrapper.twitter': paddingRight: 0, marginRight: twitter_width
        '#twitter-wrapper': 
            zIndex: 1000, position: 'fixed', right: 0, top: 50, width: twitter_width, height: '100%', paddingTop: 0
            marginRight: -twitter_width, overflowY: 'auto', background: 'rgba(200, 200, 200, 0.6)', WebkitTransition: 'all 0.8s ease'
        '#twitter-wrapper.open': 
            marginRight: 0     
        '#sidebar-wrapper': 
            display: 'flex', zIndex: 1000, position: 'fixed', width: sidebar_width, height: '100%', paddingTop: 50
            marginLeft: -sidebar_width, overflowY: 'auto', background: 'rgba(200, 200, 200, 0.6)', WebkitTransition: 'all 0.8s ease'
            #'@media(min-width:768px)': width: sidebar_width
        '#wrapper.menu #sidebar-wrapper': marginLeft: -sidebar_width
        '#content-wrapper': width: '100%', padding: 15
        '#wrapper.menu #content-wrapper': 
            position: 'absolute', marginRight: -sidebar_width
            '@media(min-width:768px)': position: 'relative', marginRight: 0
        '.sidebar-nav': position: 'absolute', top: 40, width: sidebar_width, margin: 0, padding: 0, listStyle: 'none'
        '.sidebar-nav li': textIndent: 20, lineHeight: 40
        '.sidebar-nav li a:hover': textDecoration: 'none', color: '#000', backgroundColor: '#e8e8e8'
        '.sidebar-nav li a:active, .sidebar-nav li a:focus': textDecoration: 'none', color: '#000', backgroundColor: '#ddd'
        '.sidebar-nav > .sidebar-brand': height: 65, fontSize: 18, lineHeight: 60
        '.sidebar-nav > .sidebar-brand a': color: '#999'
        '.sidebar-nav > .sidebar-brand a:hover': color: '#fff', background: 'none'
    jade:
        'form#listen-to-menu-change': ''
        '#sidebar-wrapper':
            '#sidebar-top': ''
            'ul.sidebar-nav': 
                'each sites':
                    '+side_menu_list': ''
                    
    helpers:
        sites: -> db.ConstructionSite.find {}, sort: started: -1

