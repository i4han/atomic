

collections = if (s = Meteor.settings) and s.public then x.toArray s.public.collections else []

db_server = ->
    collections.map (collection) ->
        db[collection] = new Meteor.Collection collection
        db[collection].allow
            insert: (doc) -> true
            update: (userId, doc, fields, modifier) -> true 
            remove: (userId, doc) -> true
        db[collection].deny
            update: (userId, doc, fields, modifier) -> false
            remove: (userId, doc) -> false
        Meteor.publish collection, -> db[collection].find {}

db_client = ->
    collections.map (collection) ->
        db[collection] = new Meteor.Collection collection
        Meteor.subscribe collection

Meteor.startup ->
    x.keys(exports).map (file) -> Module[key] = val for key, val of exports[file]
        .filter (n) -> n[0..1] == '__' and delete Module[n]
    x.keys(@Module = Module).map (n) -> x.module.call @, n, Module[n]
    if Meteor.isServer
        collections and db_server()
        x.keys(Module).map (name) -> (methods = Module[name].methods) and Meteor.methods methods
    else if Meteor.isClient
        collections and db_client()
        Router.configure layoutTemplate: 'layout'
        x.keys(Module).map (name) ->
            _ = Module[name]  
            _.onStartup and _.onStartup.call(_)
            _.router    and console.log('O') or Router.map -> @route name, x.extend _.router #, data: -> Session.set 'params', @params
            _.events    and Template[name].events x.tideEventKey x.func(_.events, _), _.id
            _.helpers   and Template[name].helpers x.func _.helpers, _
            _.on$Ready  and $ ($) -> _.on$Ready.call(_)
            ('onCreated onRendered onDestroyed'.split ' ').forEach (d) -> 
                _[d] and Template[name][d] -> _[d].call(_)
        $ ($) -> 
            o.$.map (f) -> f()
            $.fn[k] = x.$[k] for k of x.$

