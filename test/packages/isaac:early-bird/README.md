
## Early Bird
Early-bird uses [json configureation file](http://docs.meteor.com/#/full/meteor_settings) to set Environment Variables used by Meteor. It is especially needed when you deploy your app to meteor.com. The option doesn't provide a way to setup Environment Variables to be required by your app such as `MONGO_URL` or `MAIL_URL`.

## Use
    $ cd your-meteor-project-directory
    $ cat settings.json
    {
        "env": {
            "production": {
                "MONGO_URL": "mongodb://foobarmongo.com:27017/meteor"
            }
            "development": {
            	"MONGO_URL": "mongodb://localhost:27017/meteor"
            }
        }
    }    /* your other settings read by Meteor.settings can be together in this file. */
     
    $ meteor run --settings settings.json     // MONGO_URL=mongodb://localhost:27017/meteor
    $ meteor deploy --settings settings.json  // MONGO_URL=mongodb://foobarmongo.com:27017/meteor
     
     
## Setup
     
    $ cd your-meteor-project-directory
    $ meteor add isaac:early-bird
    
   
When you install early-bird package it will automatically put it's position in the beginning so it will do its required work before other meteor packages are loaded.

## Issues
If you have questions? Send me. isaac@hi16.ca

