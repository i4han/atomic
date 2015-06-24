// Generated by CoffeeScript 1.6.2
var collections;

collections = function() {
  return {
    Users: {
      publish: function() {
        return this.Matches = db.Users.find({
          gender: 'F',
          public_ids: {
            $exists: true
          },
          location: {
            $near: {
              $geometry: {
                type: "Point",
                coordinates: [-118.3096648, 34.0655627]
              },
              $maxDistance: 20000,
              $minDistance: 0
            }
          }
        });
      },
      callback: function() {
        window.Matches = db.Users.find({}).fetch();
        return this.UserReady();
      },
      collections: {
        "fs.files": {
          publish: function() {
            return this.Files = db["fs.files"].find({
              _id: {
                $in: this.Matches.fetch().reduce((function(o, a) {
                  return o.concat(a.photo_ids);
                }), [])
              }
            });
          },
          callback: function() {
            return this.Files = db['fs.files'].find({}).fetch();
          },
          collections: {
            "fs.chunks": {
              publish: function() {
                return db["fs.chunks"].find({
                  files_id: {
                    $in: this.Files.fetch().map(function(a) {
                      return a._id;
                    })
                  }
                });
              },
              callback: function() {
                return this.Chunks = db['fs.chunks'].find({}).fetch();
              }
            }
          }
        }
      }
    }
  };
};

exports.Parts = function() {
  return {
    title: function(_, v) {
      return blaze.Include(_, 'contentFor', {
        headerTitle: ''
      }, html.H1(_, {
        "class": 'title'
      }, v));
    },
    $header1: function(t) {
      return HEADER(this, {
        _bar: '* *-nav',
        _: H1(this, {
          _title: {
            _: t
          }
        })
      });
    },
    $header2: function(t) {
      return DIV(this, {
        _bar: '* *-header *-light',
        _: H1(this, {
          "class": 'title'
        }, t)
      });
    },
    $class: function(v) {
      return DIV(this, {
        "class": v
      });
    },
    $id: function(v) {
      return DIV(this, {
        id: v
      });
    },
    $header: function(v) {
      return blaze.include(this, 'contentFor', {
        headerTitle: ''
      }, H1(this, {
        "class": 'title'
      }, v.title));
    },
    $content: function(v) {
      return DIV(this, {
        "class": 'content',
        _: v
      });
    },
    $btnBlock: function(v) {
      return {
        _button: '* *-block',
        id: v
      };
    },
    $mp: function(v) {
      return {
        margin: v,
        padding: v
      };
    },
    $tabItem: function(v) {
      return {
        "class": 'tab-item',
        href: v,
        dataIgnore: 'push'
      };
    },
    $box: function(a) {
      return {
        width: a[0],
        height: a[1]
      };
    },
    $padded: function(v) {
      return DIV(this, {
        "class": 'content'
      }, DIV(this, {
        "class": 'content-padded'
      }, v));
    },
    $subfooter: function(v) {
      return {
        _bar: '* *-standard *-footer-secondary',
        _: v
      };
    },
    $fixedTop: function(v) {
      return {
        position: 'fixed',
        top: v
      };
    },
    $fixedBottom: function(v) {
      return {
        position: 'fixed',
        bottom: v
      };
    },
    $photoCard: function(v) {
      return {
        background: 'white',
        borderRadius: 2,
        padding: v || '8px 6px',
        boxShadow: '1px 1px 5px 1px'
      };
    }
  };
};

exports.Modules = function() {
  var bottom, box, height, pic_height, pic_top, swipe, top, width;

  width = 375;
  height = 667;
  box = width / 5;
  top = 22;
  bottom = 44;
  swipe = 22;
  pic_top = top + box;
  pic_height = height - (pic_top + bottom);
  return {
    layout: function() {
      return {
        template: function() {
          return ionic.Body(this, ionic.NavBar(this, {
            "class": 'bar-royal'
          }), ionic.NavView(this, blaze.Include(this, 'yield')), blaze.Include(this, 'tabs'));
        },
        head: function() {
          return [
            html.META(this, {
              name: 'viewport',
              content: 'width=device-width initial-scale=1.0, user-scalable=no'
            }), html.TITLE(this, Settings.title)
          ];
        }
      };
    },
    tabs: {
      template: function() {
        var _this = this;

        return ionic.Tabs(this, {
          _tabs: '*-icon-top'
        }, blaze.Each(this, 'tabs', function() {
          return ionic.Tab(_this, {
            title: '{label}',
            path: '{name}',
            iconOff: '{icon}',
            iconOn: '{icon}'
          });
        }));
      },
      helpers: {
        tabs: function() {
          return 'chat camera spark settings profile'.split(' ').map(function(a) {
            return Modules[a];
          });
        }
      }
    },
    profile: function() {
      return {
        icon: 'person',
        path: 'profile',
        template: function() {
          var _this = this;

          return [
            part.title(this, 'Profile'), ionic.Content(this, ionic.List(this, {
              "class": 'profile'
            }, blaze.Each(this, 'items', function() {
              return ionic.Item(_this, {
                buttonRight: true
              }, html.H2(_this, 'title {title} content &#123; &#125; {content} works!'), html.P(_this, cube.viewLookup(_this, 'content')), html.BUTTON(_this, {
                _button: '* *-positive'
              }, ionic.Icon(_this, {
                icon: 'ios-telephone'
              })));
            }))), ionic.SubfooterBar(this, html.BUTTON(this, {
              $btnBlock: 'facebook'
            }, 'login with facebook'))
          ];
        },
        style: {
          b0: {
            bottom: 70
          }
        },
        helpers: {
          items: function() {
            return [
              {
                title: 'hello',
                content: 'world'
              }, {
                title: 'hello1',
                content: 'world1'
              }, {
                title: 'hello2',
                content: 'world2'
              }, {
                title: 'hello3',
                content: 'world3'
              }
            ];
          },
          token: function() {
            return facebookConnectPlugin.getAccessToken((function(token) {
              return Session.set('fbToken', token);
            }), (function() {}));
          }
        },
        events: {
          'touchend #facebook': function() {
            return facebookConnectPlugin.login(['publish_actions'], (function() {
              facebookConnectPlugin.getAccessToken((function(token) {
                return Session.set('fbToken', token);
              }), function(e) {
                return console.log('Token fail', e);
              });
              facebookConnectPlugin.api('me', ['public_profile'], (function(data) {
                return Session.set('fbProfile', data);
              }), function(e) {
                return console.log('API fail', e);
              });
              return facebookConnectPlugin.getLoginStatus((function(data) {
                return console.log(data);
              }), function(e) {
                return console.log('Login Status fail', e);
              });
            }), function(e) {
              console.log('Login fail', e);
              facebookConnectPlugin.api('me', ['public_profile'], (function(data) {
                console.log('fb Profile get', data);
                return Session.set('fbProfile', data);
              }), function(e) {
                return console.log('API fail', e);
              });
              return facebookConnectPlugin.getLoginStatus((function(data) {
                return console.log(data);
              }), function(e) {
                return console.log('Login Status fail', e);
              });
            });
          }
        },
        _onRendered: function() {
          $.ajaxSetup({
            cache: true
          });
          return $.getScript('//connect.facebook.net/en_US/sdk.js', function() {
            FB.init({
              appId: '839822572732286',
              version: 'v2.3'
            });
            return FB.getLoginStatus(function(d) {
              return console.log('FB login', d);
            });
          });
        }
      };
    },
    settings: {
      icon: 'gear-a',
      path: 'settings',
      template: function() {
        return [
          part.title(this, 'Settings'), ionic.View(this, ionic.Content(this, html.P(this, 'hello world!'))), ionic.SubfooterBar(this, html.BUTTON(this, {
            $btnBlock: 'logout'
          }, 'logout'))
        ];
      },
      events: {
        'touchend #logout': function() {
          return facebookConnectPlugin.logout((function() {
            return Router.go('profile');
          }), (function(e) {
            return console.log('logout error', e);
          }));
        }
      }
    },
    chat: {
      icon: 'chatbubbles',
      path: 'chat',
      template: function() {
        var _this = this;

        return [
          part.title(this, 'Chat'), html.DIV(this, {
            "class": 'content'
          }, html.DIV(this, {
            "class": 'content-padded'
          }, blaze.Each(this, 'chats', function() {
            return html.DIV(_this, {
              id: '{id}',
              _chat: '* *-{side}'
            }, '{text}');
          }))), ionic.SubfooterBar(this, html.INPUT(this, {
            id: 'chat-input0',
            type: 'text'
          }))
        ];
      },
      style: {
        _contentPadded: {
          $fixedBottom: bottom * 2
        },
        _chat: {
          display: 'block'
        },
        _chatMe: {
          color: 'black'
        },
        _chatYou: {
          marginLeft: 20
        },
        _chatRead: {
          color: 'grey'
        },
        input0: {
          $fixedBottom: bottom,
          $box: ['100%', bottom],
          $mp: 0,
          border: 0
        }
      },
      helpers: {
        chats: function() {
          return db.Chats.find({});
        }
      },
      events: function() {
        var _this = this;

        return {
          'keypress _[#input0]': function(e) {
            var Jinput, text;

            if (e.keyCode === 13 && (text = (Jinput = $(_this.Id('#input0'))).val())) {
              Jinput.val('');
              return Meteor.call('says', 'isaac', text);
            }
          }
        };
      },
      methods: {
        says: function(id, text) {
          return db.Chats.insert({
            id: id,
            text: text
          });
        }
      },
      collections: {
        Chats: {}
      }
    },
    spark: function() {
      var choose, icon_index, pass, push, setImage,
        _this = this;

      this.Matches = [];
      icon_index = 0;
      setImage = function(id, i) {
        return Session.set('img-photo-id', Matches[i].public_ids[0]);
      };
      pass = function(J) {
        return J.animate({
          top: '+=1000'
        }, 600, function() {
          return J.remove();
        });
      };
      choose = function(J) {
        return J.animate({
          top: top,
          width: box,
          left: box * icon_index++,
          clip: 'rect(0px, 75px, 75px, 0px)'
        }, 500, function() {
          return J.switchClass('photo-touched', 'icon', 300);
        });
      };
      push = function(i) {
        var Jfront, loaded, photo;

        loaded = true;
        Jfront = $('#photo-' + i);
        photo = Settings.image_url + Matches[i].public_ids[0];
        return Jfront.switchClass('photo-back', 'photo-front', 0, function() {
          return $('#photo-' + (i + 1)).css({
            left: 0..after(HTML.toHTML(html.IMG(this, {
              id: 'photo-' + (i + 1),
              _photo: '* *-back',
              src: photo + '.jpg'.draggable({
                axis: 'y'.on('touchstart', function(e) {
                  return Jfront.switchClass('photo-front', 'photo-touched', 100..on('touchend', function(e) {
                    switch (false) {
                      case !(e.target.y > pic_top + swipe):
                        return push(i + 1) && pass(Jfront);
                      case !(e.target.y < pic_top - swipe):
                        return push(i + 1) && choose(Jfront);
                      default:
                        return Jfront.switchClass('photo-touched', 'photo-front', 100, function() {
                          return Jfront.animate({
                            top: pic_top
                          }, 100);
                        });
                    }
                  }));
                })
              })
            })))
          });
        });
      };
      return {
        icon: 'flash',
        path: '/',
        template: function() {
          return [
            part.title(this, 'Spark'), html.DIV(this, {
              "class": 'content'
            }, html.IMG(this, {
              _photo: '* *-back',
              id: 'photo-0',
              src: 'spark0.jpg'
            }))
          ];
        },
        style: {
          _photo: {
            $fixedTop: pic_top,
            width: width,
            background: 'white',
            overflow: 'hidden'
          },
          _icon: {
            zIndex: 20,
            width: box,
            top: top,
            clip: 'rect(0px, 75px, 75px, 0px)'
          },
          _photoFront: {
            zIndex: 10,
            top: pic_top
          },
          _photoBack: {
            zIndex: -10,
            left: width
          },
          _photoTouched: {
            zIndex: 30,
            width: width - 1,
            $photoCard: ''
          }
        },
        collections: function() {
          return collections.call(this);
        },
        fn: {
          UserReady: function() {
            return push(0);
          }
        }
      };
    },
    camera: function() {
      var upload, uploadPhoto;

      uploadPhoto = function(uri) {
        var ft, o, options;

        return (ft = new FileTransfer()).upload(uri, Settings.upload, (function(r) {
          return console.log('ok', r);
        }), (function(r) {
          return console.log('err', r);
        }), x.assign(options = new FileUploadOptions(), o = {
          fileKey: 'file',
          fileName: uri.slice(uri.lastIndexOf('/') + 1),
          mimeType: 'image/jpeg',
          chunkedMode: true,
          params: {
            id: 'isaac'
          }
        }));
      };
      upload = function(url) {
        return resolveLocalFileSystemURL(url, (function(entry) {
          return entry.file((function(data) {
            var l;

            return console.log('data', data) || uploadPhoto(l = data.localURL);
          }), function(e) {
            return console.log(e);
          });
        }), function(e) {
          return console.log('resolve err', e);
        });
      };
      return {
        icon: 'camera',
        path: 'camera',
        template: function() {
          return [
            part.title(this, 'Camera'), html.IMG(this, {
              id: 'camera-photo',
              style: 'width:100%;'
            })
          ];
        },
        onRendered: function() {
          var options;

          return navigator.camera.getPicture((function(uri) {
            return upload(uri);
          }), (function() {}), options = {
            quality: 90,
            cameraDirection: Camera.Direction.FRONT,
            destinationType: Camera.DestinationType.FILE_URI,
            encodingType: Camera.EncodingType.JPEG,
            sourceType: Camera.PictureSourceType.CAMERA
          });
        },
        onServer: function() {
          var Busboy, cloud, fs, _;

          fs = Npm.require('fs');
          Busboy = x.require('busboy');
          cloud = x.require('cloudinary');
          _ = Settings.cloudinary;
          cloud.config({
            cloud_name: _.cloud_name,
            api_key: _.api_key,
            api_secret: _.api_secret
          });
          Router.onBeforeAction(function(req, res, next) {
            var busboy, filenames;

            filenames = [];
            if (req.url === '/upload' && req.method === 'POST') {
              busboy = new Busboy({
                headers: req.headers
              });
              busboy.on('file', function(field, file, filename) {
                console.log('param', req);
                file.pipe(cloud.uploader.upload_stream(function(r) {
                  return console.log('stream', r, req.body.id);
                }));
                return filenames.push(filename);
              });
              busboy.on('finish', function() {
                req.filenames = filenames;
                return next();
              });
              busboy.on('field', function(field, value) {
                return req.body[field] = value;
              });
              return req.pipe(busboy);
            } else {
              return next();
            }
          });
          return Router.route('/upload', {
            where: 'server'
          }).post(function() {
            this.response.writeHead(200, {
              'Content-Type': 'text/plain'
            });
            return this.response.end("ok");
          });
        }
      };
    },
    chosenbox: {
      template: function() {
        return html.DIV(this, {
          _chosen: '*-container',
          id: "chosen-{id}",
          style: "left:{left}px;"
        }, html.IMG(this, {
          id: "chosen-box-{id}"
        }));
      },
      style: {
        _chosenContainer: {
          $fixedTop: top,
          $box: [box, box],
          zIndex: 200,
          border: 3,
          overflowY: 'hidden'
        }
      }
    },
    chosen: {
      template: function() {
        return html.DIV(this, {
          id: 'chosen'
        }, blaze.Each(this, {
          chosen: blaze.Include(this, 'chosenbox')
        }));
      },
      helpers: {
        chosen: [0, 1, 2, 3, 4].map(function(i) {
          return {
            id: i,
            left: box * i
          };
        })
      }
    }
  };
};

exports.Settings = function() {
  var deploy_domain, local_ip;

  local_ip = '192.168.1.78';
  deploy_domain = 'spark5.meteor.com';
  return {
    app: {
      info: {
        id: 'com.spark.game',
        name: 'Spark game',
        description: 'Spark game long name.',
        website: 'http://sparkgame.com'
      },
      icons: {
        iphone: 'resources/icons/icon-60x60.png',
        iphone_2x: 'resources/icons/icon-60x60@2x.png'
      },
      setPreference: {
        BackgroundColor: '0xff0000ff',
        HideKeyboardFormAccessoryBar: true
      },
      configurePlugin: {
        'com.phonegap.plugins.facebookconnect': {
          APP_NAME: 'spark-game-test',
          APP_ID: process.env.FACEBOOK_CLIENT_ID,
          API_KEY: process.env.FACEBOOK_SECRET
        }
      },
      accessRule: ["http://localhost/*", "http://meteor.local/*", "http://" + local_ip + "/*", "http://connect.facebook.net/*", "http://*.facebook.com/*", "https://*.facebook.com/*", "ws://" + local_ip + "/*", "http://" + deploy_domain + "/*", "ws://" + deploy_domain + "/*", "http://res.cloudinary.com/*", "mongodb://ds031922.mongolab.com/*"]
    },
    deploy: {
      name: 'spark5',
      mobileServer: 'http://spark5.meteor.com'
    },
    title: function() {
      return this.app.info.name;
    },
    theme: "clean",
    lib: "ui",
    env: {
      production: {
        MONGO_URL: process.env.MONGO_URL
      }
    },
    npm: {
      busboy: "0.2.9",
      cloudinary: "1.2.1"
    },
    "public": {
      collections: {},
      image_url: "http://res.cloudinary.com/sparks/image/upload/",
      upload: "http://" + local_ip + ":3000/upload"
    },
    cloudinary: {
      cloud_name: "sparks",
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET
    },
    facebook: {
      oauth: {
        version: 'v2.3',
        url: "https://www.facebook.com/dialog/oauth",
        options: {
          query: {
            client_id: process.env.FACEBOOK_CLIENT_ID,
            redirect_uri: 'http://localhost:3000/home'
          }
        },
        secret: process.env.FACEBOOK_SECRET,
        client_id: process.env.FACEBOOK_CLIENT_ID
      }
    }
  };
};